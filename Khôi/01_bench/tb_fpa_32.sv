`timescale 1ns/1ps
// synopsys translate_off
// synthesis translate_off
`ifndef SYNTHESIS

module tb_fpa_32;

  // ---------------- DUT ----------------
  logic [31:0] a, b, y;
  fpa dut (.operand_a(a), .operand_b(b), .result(y));

  // -------------- Constants --------------
  localparam logic [31:0] QNAN    = 32'h7FC0_0000;
  localparam logic [31:0] PINF    = 32'h7F80_0000;
  localparam logic [31:0] NINF    = 32'hFF80_0000;
  localparam logic [31:0] PZERO   = 32'h0000_0000;
  localparam logic [31:0] NZERO   = 32'h8000_0000;
  localparam logic [31:0] MIN_SUB = 32'h0000_0001;
  localparam logic [31:0] MAX_FIN = 32'h7F7F_FFFF;

  // -------------- Helpers --------------
  function automatic bit is_nan (input logic [31:0] x);
    is_nan = (x[30:23] == 8'hFF) && (x[22:0] != 0);
  endfunction

  // Golden reference (canonicalizes all NaNs to QNAN for determinism)
  function automatic logic [31:0] ref_add32(input logic [31:0] aa, input logic [31:0] bb);
    logic        sa, sb;
    logic [7:0]  ea, eb;
    logic [22:0] fa, fb;
    bit          a_is_nan, b_is_nan, a_is_inf, b_is_inf, a_is_zero, b_is_zero;
    shortreal    ra, rb, rc;
    logic [31:0] rr;
    begin
      sa = aa[31]; sb = bb[31];
      ea = aa[30:23]; eb = bb[30:23];
      fa = aa[22:0];  fb = bb[22:0];

      a_is_nan = (ea==8'hFF) && (fa!=0);
      b_is_nan = (eb==8'hFF) && (fb!=0);
      a_is_inf = (ea==8'hFF) && (fa==0);
      b_is_inf = (eb==8'hFF) && (fb==0);
      a_is_zero = (ea==8'h00) && (fa==0);
      b_is_zero = (eb==8'h00) && (fb==0);

      if (a_is_nan || b_is_nan) return QNAN;
      if (a_is_inf && b_is_inf) return (sa ^ sb) ? QNAN : {sa,8'hFF,23'h0};
      if (a_is_inf)            return {sa,8'hFF,23'h0};
      if (b_is_inf)            return {sb,8'hFF,23'h0};

      ra = $bitstoshortreal(aa);
      rb = $bitstoshortreal(bb);
      rc = ra + rb;
      rr = $shortrealtobits(rc);

      if (is_nan(rr)) rr = QNAN; // canonicalize any NaN
      return rr;
    end
  endfunction

  // -------------- Logging --------------
  integer fd_all, fd_fail;
  integer correct = 0, wrong = 0, total = 0;

  task automatic log_row(
    input integer fd,
    input int idx,
    input string tag,
    input logic [31:0] ta, tb, got, exp,
    input bit ok
  );
    logic       gs, es;
    logic [7:0] ge, ee;
    logic [22:0] gf, ef;
    begin
      gs = got[31]; ge = got[30:23]; gf = got[22:0];
      es = exp[31]; ee = exp[30:23]; ef = exp[22:0];
      // index,tag,a_hex,b_hex,got_hex,got_s,got_e_hex,got_f_hex,exp_hex,exp_s,exp_e_hex,exp_f_hex,verdict
      $fdisplay(fd, "%0d,%s,0x%08h,0x%08h,0x%08h,%0d,0x%02h,0x%06h,0x%08h,%0d,0x%02h,0x%06h,%s",
                idx, tag, ta, tb, got, gs, ge, gf, exp, es, ee, ef, (ok ? "PASS" : "FAIL"));
    end
  endtask

  task automatic apply_and_record(input logic [31:0] ta, tb, input string tag);
    logic [31:0] exp;
    bit          ok;
    begin
      a = ta; b = tb;
      #1; // allow comb DUT to settle
      exp = ref_add32(ta, tb);
      total++;
      ok = (y === exp);
      if (ok) correct++; else wrong++;
      log_row(fd_all,  total, tag, ta, tb, y, exp, ok);
      if (!ok) log_row(fd_fail, total, tag, ta, tb, y, exp, ok);
    end
  endtask

  // -------------- Directed special cases --------------
  typedef struct packed {logic [31:0] a, b;} pair_t;
  pair_t directed[$];

  function automatic logic [31:0] make_qnan(input logic sign, input logic [21:0] payload);
    make_qnan = {sign, 8'hFF, 1'b1, payload};
  endfunction
  function automatic logic [31:0] make_snan(input logic sign, input logic [21:0] payload);
    make_snan = {sign, 8'hFF, 1'b0, payload};
  endfunction

  // -------------- Main --------------
  initial begin
    int i;
    int N;
    int unsigned seed;
    logic [31:0] ra, rb;

    $timeformat(-9, 0, " ns", 8);

    // Open CSVs
    fd_all  = $fopen("fpa_all.csv",  "w");
    fd_fail = $fopen("fpa_fail.csv", "w");
    if (fd_all == 0 || fd_fail == 0) $fatal(2, "Cannot open output CSV files.");

    // Headers
    $fdisplay(fd_all,  "index,tag,a_hex,b_hex,got_hex,got_s,got_e_hex,got_f_hex,exp_hex,exp_s,exp_e_hex,exp_f_hex,verdict");
    $fdisplay(fd_fail, "index,tag,a_hex,b_hex,got_hex,got_s,got_e_hex,got_f_hex,exp_hex,exp_s,exp_e_hex,exp_f_hex,verdict");

    // Build SPECIALS first
    directed.push_back('{PINF, PINF});            // +Inf + +Inf = +Inf
    directed.push_back('{PINF, NINF});            // +Inf + -Inf = NaN
    directed.push_back('{NINF, NINF});            // -Inf + -Inf = -Inf
    directed.push_back('{PINF, 32'h4120_0000});   // +Inf + 10.0 = +Inf
    directed.push_back('{NINF, 32'hC120_0000});   // -Inf + -10.0 = -Inf
    directed.push_back('{PZERO, PZERO});          // +0 + +0
    directed.push_back('{PZERO, NZERO});          // +0 + -0
    directed.push_back('{NZERO, NZERO});          // -0 + -0
    directed.push_back('{32'h3F800000, 32'hBF800000}); // 1.0 + -1.0
    directed.push_back('{MIN_SUB, MIN_SUB});      // tiny + tiny (subnormals)
    directed.push_back('{32'h0080_0000, MIN_SUB});
    directed.push_back('{MAX_FIN, 32'h3F800000}); // overflow to Inf (expected)
    directed.push_back('{32'h4F000000, 32'h4E800000}); // large normals
    directed.push_back('{make_qnan(1'b0, 22'h123456), 32'h3F800000}); // qNaN + 1.0 -> NaN
    directed.push_back('{make_snan(1'b0, 22'h2), 32'h40000000});      // sNaN + 2.0 -> NaN
    directed.push_back('{32'h40400000, make_qnan(1'b0, 22'h3)});      // 3.0 + qNaN -> NaN
    directed.push_back('{32'h3F7FFFFF, 32'hBF7FFFFE});                // close cancel

    // Run SPECIALS
    for (i = 0; i < directed.size(); i++) begin
      apply_and_record(directed[i].a, directed[i].b, $sformatf("dir[%0d]", i));
    end

    // Randoms
    N    = 1_000_000;            // change if needed
    seed = 32'hC0FF_EE01;
    void'($urandom(seed));       // seed ONCE

    for (i = 0; i < N; i++) begin
      ra = $urandom();
      rb = $urandom();
      apply_and_record(ra, rb, "rand");
      if ((i % 100000) == 0)
        $display("Progress: %0d / %0d (correct=%0d, wrong=%0d)", i, N, correct, wrong);
    end

    // Summary
    $display("------------------------------------------------------------");
    $display("Floating-Point Adder Test Summary:");
    $display(" Directed: %0d  Random: %0d  Total: %0d", directed.size(), N, total);
    $display(" Correct : %0d  Wrong : %0d", correct, wrong);

    $fclose(fd_all);
    $fclose(fd_fail);

    if (wrong == 0) begin
      $display("✅ TEST PASSED: All results matched reference.");
      $finish;
    end else begin
      $fatal(1, "❌ TEST FAILED: %0d mismatches out of %0d. See fpa_fail.csv", wrong, total);
    end
  end

endmodule

`endif
// synthesis translate_on
// synopsys translate_on
