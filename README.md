# Simple Microprocessor on FPGA

This project implements a **basic microprocessor** in SystemVerilog on the **Terasic DE0-CV (Cyclone V)** board.  
The design includes a program counter, instruction memory, register file, ALU, and control logic to support a small instruction set.

---

## 📖 Project Overview

The microprocessor is a **12-bit instruction CPU** with the following features:

- **Instruction memory (ROM):**
  - 64 instruction locations.
  - Preloaded with instructions using a `.mif` file (`instructions.mif`).

- **Register file:**
  - 8 registers.
  - Each register is **6 bits wide**.
  - Supports two read ports and one write port.

- **ALU:**
  - Supports addition and multiplication.
  - Multiplication outputs the lower 8 bits of the product.

- **Instruction Set:**
  | Opcode | Mnemonic | Description |
  |--------|-----------|-------------|
  | `001`  | **LDI** | Load immediate → `RD = {RA, RB}` |
  | `010`  | **ADD** | Add → `RD = RA + RB` |
  | `011`  | **ADI** | Add immediate → `RD = RA + imm` |
  | `100`  | **MUL** | Multiply → `RD = RA * RB` (low 8 bits) |
  | `101`  | **CMPJ** | Compare and jump if RA ≥ RB → increment PC by RD |
  | `110`  | **JMP** | Jump to address `{RA, RB}` |
  | `111`  | **NOP** | No operation |
  | `000`  | **HALT** | Stop execution |

---

## ⚙️ Processor Components

- **Program Counter (PC):**
  - Holds the current instruction address.
  - Normally increments by 1 each cycle.
  - Can be modified by jump instructions.

- **Instruction Register (IR):**
  - Captures the current instruction.
  - Fields: **OPCODE, RA, RB, RD**.

- **Register File:**
  - Stores working values.
  - Accessed by RA and RB (read) and RD (write).

- **ALU:**
  - Executes arithmetic and logical instructions.
  - Drives results into the register file.

---

## 🖥️ FPGA Board Behavior (DE0-CV)

- **Reset (`SW0`)**  
  Asynchronous active-high reset. Clears PC and register file.

- **Clock**  
  Uses the **on-board 50 MHz oscillator**.

- **Single-step mode (`SW1`)**  
  - `SW1 = 0`: Processor runs continuously until `HALT`.  
  - `SW1 = 1`: Processor executes one instruction at a time. Use `KEY0` to advance.

- **LEDs (LED[7:0])**  
  Display the current **program counter (PC)** value.

- **HEX Display output (selected by SW4–SW2):**

  | SW4 | SW3 | SW2 | Display |
  |-----|-----|-----|---------|
  | 0   | 0   | 0   | Register file value at address {SW7,SW6,SW5} |
  | 0   | 0   | 1   | Instruction Register (IR) |
  | 0   | 1   | 0   | Program Counter (PC) |
  | 0   | 1   | 1   | Opcode |
  | 1   | 0   | 0   | ALU Output |
  | 1   | 0   | 1   | Debug |
  | 1   | 1   | 0   | Debug |
  | 1   | 1   | 1   | Debug |

---

## 📂 Repository Structure

| File | Description |
|------|-------------|
| `microprocessor.sv` | Top-level CPU module (PC, IR, ALU, register file, control logic). |
| `ourRegister.sv` | Register file implementation. |
| `counter.sv` | General-purpose counter utility. |
| `ourDff.sv` | Basic D flip-flop with reset. |
| `ourHex.sv` | 7-segment HEX driver for display outputs. |
| `instructions.mif` | Memory initialization file (ROM contents for instruction memory). |
| `microprocessor.qpf` | Quartus project file. |
| `microprocessor.qsf` | Quartus settings & DE0-CV pin assignments. |
| `c5_pin_model_dump.txt` | Cyclone V pin model reference. |
| `Lab_4.pdf` | (Original lab instructions — summarized in this README). |

---

## 🚀 Build & Run Instructions

1. Open the project in **Quartus Prime Standard (22.1 or compatible)**.  
   - Load `microprocessor.qpf`.
2. Compile the design (`Ctrl+L`).
3. Program the **DE0-CV** board via USB-Blaster.
4. Run in either:
   - **Full-speed mode** (SW1 = 0): executes continuously until `HALT`.
   - **Single-step mode** (SW1 = 1): press `KEY0` to execute each instruction manually.
5. Use **SW4–SW2** to select output for the 7-segment HEX displays.

---

## 🧪 Example Program

The default `instructions.mif` file contains a sample program that demonstrates load, add, multiply, and jump instructions.  
You can edit this file to try new instruction sequences — recompile in Quartus to load updated instructions into ROM.

---


## 👤 Author

FPGA project by **Benjamin Tung**.  
