// Author: Hai Cao
// Copyright 2024

// TASK: Clock Generator
task automatic tsk_clock_gen(ref logic i_clk, input int CLK_PERIOD);
  begin
    i_clk = 1'b1;
    forever #(CLK_PERIOD) i_clk = !i_clk;
  end
endtask



// TASK: Reset is low active for a period of "RESETPERIOD"
task automatic tsk_reset(ref logic i_reset, input int RESET_PERIOD);
  begin
    i_reset = 1'b0;
    #(RESET_PERIOD) i_reset = 1'b1;
  end
endtask



// TASK: Timeout, assume after a period of "FINISH",
// the design is supposed to be "PASSED"
task automatic tsk_timeout(input int FINISH);
  begin
    #FINISH $display("\nTimeout...\n\n");
            $finish;
  end
endtask
