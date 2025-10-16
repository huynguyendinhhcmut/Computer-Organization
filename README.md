# 💻 EE3043: Computer Architecture - Pipelined RISC-V Processor

This repository contains the design, implementation, and verification files for the Computer Architecture course project at HCMC University of Technology, VNU-HCM.

The project is a progression through three milestones, culminating in the design and performance analysis of various **pipelined RISC-V (RV32I) processors**. All designs are intended to be **synthesizable** and implemented on a **DE2 FPGA board**.

---

## 🎯 Project Objectives

* **Design a single-cycle RV32I processor** (Milestone 2).
* **Design three pipelined processors** to review and apply concepts of hazards and forwarding.
* **Measure and compare performance** using **Instructions Per Cycle (IPC)** as the criterion.
* Implement various **branch prediction schemes** and measure their **hit/miss ratio** (for advanced models).

---

## 📂 Repository Structure

The project maintains a well-organized directory hierarchy for efficient management and submission:

| Directory | Description |
| :--- | :--- |
| `00_src` | Verilog/SystemVerilog source files (RTL)  |
| `01_bench` | Testbench files for simulation and verification  |
| `02_test` | Testing files  |
| `02_test/asm` | Assembly test code  |
| `02_test/dump` | Binary/hex dump files  |
| `10_sim` | Simulation files  |
| `20_syn` | Synthesis files (e.g., Quartus project files)  |
| `99_doc` | Documentation files and project reports  |

---

## 📌 Milestone Breakdown

### Milestone 1: Vending Machine Design 🍬

This milestone focused on reviewing basic logic design and **FSM concepts** using SystemVerilog.

* **Task**: Design a Vending Machine controller that accepts nickels ($5\text{¢}$), dimes ($10\text{¢}$), and quarters ($25\text{¢}$).
* **Function**: Dispense a soda and calculate the correct change when the deposited amount exceeds $20\text{¢}$.

### Milestone 2: Single-Cycle RV32I Processor ⚙️

This milestone involved designing a full **single-cycle RV32I processor**.

#### Key Components:
* **ALU**: Executes RV32I arithmetic and logical operations.
* **BRC (Branch Comparison Unit)**: Handles signed and unsigned comparisons for branch instructions.
* **Regfile**: 32-register, 32-bit register file with two read ports and one write port.
* **LSU (Load-Store Unit) / I/O System**: Manages memory-mapped I/O for peripherals (LEDs, switches, 7-segment displays, LCD) and memory.
    * **Instruction Memory**: `0x0000` to `0x1FFF` (8KiB).
    * **Data Memory**: `0x2000` to `0x3FFF` (8KiB).

### Milestone 3: Pipelined Processors and Performance Analysis 🚀

This is the main focus on designing and comparing three pipelined models chosen from the options below.

#### Pipelined Processor Models:

| Model | Description | Key Mechanism | Advanced Design Applicable? |
| :--- | :--- | :--- | :--- |
| **Model 1** | **Non-forwarding** | **Hazard Detector** to stall on **RAW hazards**; no branch predictor (flush/stall on taken branch). | No |
| **Model 2** | **Forwarding** | **Forwarding Unit** to resolve **RAW hazards**; **Always-not-taken** branch assumption. | No |
| **Model 3** | **Always-taken** | **Branch Target Buffer (BTB)** implementation; static branch prediction. | No |
| **Model 4** | **One-bit prediction** | Modification of Model 3 with a **one-bit prediction scheme**. | Yes  |
| **Model 5** | **Two-bit prediction** | Modification of Model 3 with a **two-bit prediction scheme**. | Yes  |
| **Model 6** | **G-share prediction** | Modification of Model 3 with **G-share prediction**. | Yes  |
| **Model 7** | **Your ideas** | Custom modified pipelined processor (e.g., more/less stages, different prediction). | Yes  |

> **Note**: The **Advanced Design** score is only applicable if you choose and implement Model 4, 5, 6, or 7.

#### Performance Evaluation:

Performance measurements and comparison must use **IPC**. For models 4 through 7, the **hit or miss ratio** of the predictor must be included in the report.

---

## 📖 Report Guidelines

A comprehensive report is required for submission. The M3 report must include the following content sections:

1.  Student name, student ID, and group ID.
2.  Title.
3.  Introduction.
4.  Design Strategy.
5.  Verification Strategy.
6.  Advanced Design (if applicable).
7.  Evaluation.
8.  Conclusion.
