# 💻 EE3043: Computer Architecture - Pipelined RISC-V Processor

This repository contains the design, implementation, and verification files for the Computer Architecture course project at HCMC University of Technology, VNU-HCM.

The project is a progression through three milestones, culminating in the design and performance analysis of various **pipelined RISC-V (RV32I) processors**. All designs are intended to be **synthesizable** and implemented on a **DE2 FPGA board**.

---

## 🎯 Project Objectives

* **Design a single-cycle RV32I processor**.
* **Design several models of pipelined processors** for comparison, exploring pipeline techniques and addressing limitations.
* **Explore the Branch Prediction technique**.
* **Measure and compare performance** using **Instructions Per Cycle (IPC)** as the criterion.

---

## 📂 Repository Structure

The project maintains a well-organized directory hierarchy for efficient management and submission:

| Directory | Description |
| :--- | :--- |
| `00_src` | Verilog/SystemVerilog source files (RTL) |
| `01_bench` | Testbench files |
| `02_test` | Testing files containing assembly test code and dump files |
| `02_test/asm` | Assembly test code |
| `02_test/dump` | Binary/hex dump files |
| `10_sim` | Simulation scripts/files for **Verilator**  |
| `11_xm` | Simulation scripts/files for **Cadence Xcelium** |
| `20_syn` | Synthesis files |
| `99_doc` | Documentation files and project reports  |

---

## 📌 Milestone Breakdown

### Milestone 1: Vending Machine Design 🍬

This milestone focused on reviewing basic logic design and **Finite State Machine (FSM) concepts** using SystemVerilog.

* **Task**: Design a Vending Machine controller that accepts coins: **$5\text{¢}$ (Nickel)**, **$10\text{¢}$ (Dime)**, and **$25\text{¢}$ (Quarter)**.
* **Function**: Dispense a soda and calculate the correct change when the deposited amount **exceeds $20\text{¢}$**.

---

### Milestone 2: Single-Cycle RV32I Processor ⚙️

This milestone involved designing a full **single-cycle RV32I processor** (top-level module: `singlecycle.sv` ).

#### Key Components:
* **ALU**: Executes arithmetic and logical operations defined by the RV32I instruction set.
* **BRC (Branch Comparison Unit)**: Compares two register values, handling both signed and unsigned comparisons.
* **Regfile**: 32-register, 32-bit register file with two asynchronous read ports and one synchronous write port.
* **LSU (Load-Store Unit) / I/O System**: Manages memory and memory-mapped I/O for peripherals.

#### Memory and I/O Mapping (LSU Table 1):

| Base Address | Top Address | Mapping | Required? |
| :--- | :--- | :--- | :--- |
| `0x0000_0000` | `0x0000_07FF` | Memory (2 KiB) | Yes |
| `0x1000_0000` | `0x1000_0FFF` | Red LEDs | Yes |
| `0x1000_1000` | `0x1000_1FFF` | Green LEDs | Yes |
| `0x1000_2000` | `0x1000_2FFF` | Seven-segment LEDs 3-0 | Optional |
| `0x1000_3000` | `0x1000_3FFF` | Seven-segment LEDs 7-4 | Optional |
| `0x1000_4000` | `0x1000_4FFF` | LCD Control Registers | Optional |
| `0x1001_0000` | `0x1001_0FFF` | Switches | Yes |

---

### Milestone 3: Pipelined Processors and Performance Analysis 🚀

The focus is on designing and comparing at least **two models of pipelined processors** (top-level module: `pipelined.sv` ) using synchronous read/write memory models.

#### Memory and I/O Mapping (Table 1):

| Base Address | Top Address | Mapping | Required? |
| :--- | :--- | :--- | :--- |
| `0x0000_0000` | `0x0000_FFFF` | Memory (64 KiB) | Yes |
| `0x1000_0000` | `0x1000_0FFF` | Red LEDs | Yes |
| `0x1000_1000` | `0x1000_1FFF` | Green LEDs | Yes |
| `0x1000_2000` | `0x1000_2FFF` | Seven-segment LEDs 3-0 | Optional |
| `0x1000_3000` | `0x1000_3FFF` | Seven-segment LEDs 7-4 | Optional |
| `0x1000_4000` | `0x1000_4FFF` | LCD Control Registers | Optional |
| `0x1001_0000` | `0x1001_0FFF` | Switches | Yes |

#### Pipelined Processor Models (Select 2 or more):

| Model | Description | Key Mechanism | Bonus Credit |
| :--- | :--- | :--- | :--- |
| **Non-forwarding** | Incorporates **Hazard Detection** to use **stall** and **flush** signals on hazards. | Hazard Detection Unit | No |
| **Forwarding** | Adds a **Forwarding Network** to resolve hazards, requiring caution with load instructions. | Forwarding Unit | No |
| **Always Taken** | Implements static prediction via a **Branch Target Buffer (BTB)**, modifying the Fetch stage. | BTB Implementation | No |
| **Two-Bit Dynamic Branch Prediction** | Uses a straightforward **two-bit prediction scheme**. | Two-Bit Predictor | Yes  |
| **G-share Branch Prediction** | An advanced branch prediction technique. | G-share Predictor | Yes  |

#### Performance Evaluation:

* **Synthesis Data**: Record **Maximum Frequency ($F_{\text{max}}$ (MHz))**, **Total logic elements (%)**, **Total registers (%)**, and **Total memory bits (%)** for comparison.
* **Performance Data**: Record **IPC** and **Mispred Rate (%)** for the ISA test and at least one custom program.
* Utilizing **BRAMs** to enhance processor frequency earns a **1-point bonus**.

---

## 📖 Report Guidelines

A comprehensive project report is required, detailing the design process, challenges faced, and solutions implemented. Visual aids like diagrams and charts are encouraged.

The report must include sections for **introduction, methodology, results, and conclusions**. The Milestone 3 report specifically requires recording the synthesis and performance data for all implemented models.
