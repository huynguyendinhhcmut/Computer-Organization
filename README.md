# 💻 EE3043: Computer Architecture - Pipelined RISC-V Processor

This repository contains the design, implementation, and verification files for the Computer Architecture course project at HCMC University of Technology, VNU-HCM.

The project is a progression through three milestones, culminating in the design and performance analysis of various **pipelined RISC-V (RV32I) processors**. [cite_start]All designs are intended to be **synthesizable** and implemented on a **DE2 FPGA board**[cite: 18, 56].

---

## 🎯 Project Objectives

* [cite_start]**Design a single-cycle RV32I processor** (Milestone 2)[cite: 161, 166].
* [cite_start]**Design three pipelined processors** to review and apply concepts of hazards and forwarding[cite: 12, 13, 15].
* [cite_start]**Measure and compare performance** using **Instructions Per Cycle (IPC)** as the criterion[cite: 16].
* [cite_start]Implement various **branch prediction schemes** and measure their **hit/miss ratio** (for advanced models)[cite: 17].

---

## 📂 Repository Structure

[cite_start]The project maintains a well-organized directory hierarchy for efficient management and submission[cite: 222, 224]:

| Directory | Description |
| :--- | :--- |
| `00_src` | [cite_start]Verilog/SystemVerilog source files (RTL) [cite: 224] |
| `01_bench` | [cite_start]Testbench files for simulation and verification [cite: 224] |
| `02_test` | [cite_start]Testing files [cite: 224] |
| `02_test/asm` | [cite_start]Assembly test code [cite: 224] |
| `02_test/dump` | [cite_start]Binary/hex dump files [cite: 224] |
| `10_sim` | [cite_start]Simulation files [cite: 224] |
| `20_syn` | [cite_start]Synthesis files (e.g., Quartus project files) [cite: 224] |
| `99_doc` | [cite_start]Documentation files and project reports [cite: 224] |

---

## 📌 Milestone Breakdown

### Milestone 1: Vending Machine Design 🍬

[cite_start]This milestone focused on reviewing basic logic design and **FSM concepts** using SystemVerilog[cite: 100, 101].

* [cite_start]**Task**: Design a Vending Machine controller that accepts nickels ($5\text{¢}$), dimes ($10\text{¢}$), and quarters ($25\text{¢}$)[cite: 122].
* [cite_start]**Function**: Dispense a soda and calculate the correct change when the deposited amount exceeds $20\text{¢}$[cite: 124].

### Milestone 2: Single-Cycle RV32I Processor ⚙️

[cite_start]This milestone involved designing a full **single-cycle RV32I processor**[cite: 161, 166].

#### Key Components:
* **ALU**: Executes RV32I arithmetic and logical operations.
* **BRC (Branch Comparison Unit)**: Handles signed and unsigned comparisons for branch instructions.
* [cite_start]**Regfile**: 32-register, 32-bit register file with two read ports and one write port[cite: 252].
* [cite_start]**LSU (Load-Store Unit) / I/O System**: Manages memory-mapped I/O for peripherals (LEDs, switches, 7-segment displays, LCD) and memory[cite: 322, 337].
    * [cite_start]**Instruction Memory**: `0x0000` to `0x1FFF` (8KiB)[cite: 338, 348].
    * [cite_start]**Data Memory**: `0x2000` to `0x3FFF` (8KiB)[cite: 338, 349].

### Milestone 3: Pipelined Processors and Performance Analysis 🚀

[cite_start]This is the main focus on designing and comparing three pipelined models chosen from the options below[cite: 15].

#### Pipelined Processor Models:

| Model | Description | Key Mechanism | Advanced Design Applicable? |
| :--- | :--- | :--- | :--- |
| **Model 1** | **Non-forwarding** | [cite_start]**Hazard Detector** to stall on **RAW hazards**; no branch predictor (flush/stall on taken branch)[cite: 22, 24, 25]. | No |
| **Model 2** | **Forwarding** | **Forwarding Unit** to resolve **RAW hazards**; [cite_start]**Always-not-taken** branch assumption[cite: 28, 29]. | No |
| **Model 3** | **Always-taken** | [cite_start]**Branch Target Buffer (BTB)** implementation; static branch prediction[cite: 31]. | No |
| **Model 4** | **One-bit prediction** | [cite_start]Modification of Model 3 with a **one-bit prediction scheme**[cite: 34]. | [cite_start]Yes [cite: 19, 59] |
| **Model 5** | **Two-bit prediction** | [cite_start]Modification of Model 3 with a **two-bit prediction scheme**[cite: 37]. | [cite_start]Yes [cite: 19, 59] |
| **Model 6** | **G-share prediction** | [cite_start]Modification of Model 3 with **G-share prediction**[cite: 40]. | [cite_start]Yes [cite: 19, 59] |
| **Model 7** | **Your ideas** | [cite_start]Custom modified pipelined processor (e.g., more/less stages, different prediction)[cite: 45]. | [cite_start]Yes [cite: 19, 59] |

> [cite_start]**Note**: The **Advanced Design** score is only applicable if you choose and implement Model 4, 5, 6, or 7[cite: 19, 59].

#### Performance Evaluation:

[cite_start]Performance measurements and comparison must use **IPC**[cite: 16]. [cite_start]For models 4 through 7, the **hit or miss ratio** of the predictor must be included in the report[cite: 17].

---

## 📖 Report Guidelines

[cite_start]A comprehensive report is required for submission[cite: 65, 421]. [cite_start]The M3 report must include the following content sections[cite: 67]:

1.  [cite_start]Student name, student ID, and group ID[cite: 68].
2.  [cite_start]Title[cite: 69].
3.  [cite_start]Introduction[cite: 70].
4.  [cite_start]Design Strategy[cite: 71].
5.  [cite_start]Verification Strategy[cite: 72].
6.  [cite_start]Advanced Design (if applicable)[cite: 73].
7.  [cite_start]Evaluation[cite: 74].
8.  [cite_start]Conclusion[cite: 75].
