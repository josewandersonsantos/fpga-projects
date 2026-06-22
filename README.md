# FPGA Study

A personal repository for learning FPGA development, digital design, and Verilog through hands-on projects and simulations.

The goal of this repository is to build a solid understanding of digital circuits from the ground up, starting with basic combinational logic and gradually progressing toward more advanced sequential circuits, finite state machines, communication protocols, and complete FPGA projects.

---

## Learning Objectives

This repository focuses on:

* Digital Logic Fundamentals
* Verilog HDL
* Combinational Logic
* Sequential Logic
* Testbench Development
* Digital Simulation
* Waveform Analysis
* FPGA Design Methodology

All examples are simulated using **Icarus Verilog** and **GTKWave** before targeting actual FPGA hardware.

---

## Repository Structure

```text
.
├── Combinational
│   ├── AND
│   ├── OR
│   ├── XOR
│   ├── MUX
│   └── DEMUX
│
├── Sequential
│   ├── FlipFlop
│   └── FlipFlopReset
│   ├── Counter4Bits
│   ├── Counter8Bits
│   ├── ShiftRegister
│   ├── ClockDivider
│   ├── EdgeDetector
│   └── FSM_TrafficLight
├── Protocols/
|   ├── UART_TX
|   ├── UART_RX
|   ├── SPI_Master
|   └── I2C_Master
```

---

## Completed Topics

### Combinational Logic

Basic logic circuits where outputs depend only on current inputs.

| Project | Description        |
| ------- | ------------------ |
| AND     | Two-input AND gate |
| OR      | Two-input OR gate  |
| XOR     | Exclusive OR gate  |
| MUX     | Multiplexer        |
| DEMUX   | Demultiplexer      |

---

### Sequential Logic

Circuits that store state and depend on clock signals.

| Project       | Description            |
| ------------- | ---------------------- |
| FlipFlop      | Basic D Flip-Flop      |
| FlipFlopReset | D Flip-Flop with Reset |

---

## Project Layout

Most projects follow the same structure:

```text
Project/
├── Makefile
├── main.v
├── tb.v
├── sim
└── wave.vcd
```

### Files

| File       | Description                     |
| ---------- | ------------------------------- |
| `main.v`   | Hardware implementation         |
| `tb.v`     | Testbench                       |
| `Makefile` | Build and simulation automation |
| `sim`      | Generated simulation executable |
| `wave.vcd` | Waveform output                 |

---

## Running Simulations

Compile and run a project:

```bash
make
```

Open the waveform viewer:

```bash
gtkwave wave.vcd
```

Depending on the project structure:

```bash
cd Combinational/AND
make

gtkwave wave.vcd
```

---

## Required Tools

### Ubuntu / Debian / WSL

Install:

```bash
sudo apt update
sudo apt install iverilog gtkwave make
```

Verify installation:

```bash
iverilog -V
gtkwave --version
make --version
```

---

## Current Learning Roadmap

The repository currently covers:

* Logic Gates
* Multiplexers
* Demultiplexers
* Flip-Flops
* Reset Logic

Planned topics include:

* Counters
* Shift Registers
* Clock Dividers
* Edge Detectors
* Finite State Machines (FSM)
* PWM Controllers
* UART Transmitter
* UART Receiver
* SPI Controller
* I2C Controller
* Memory Interfaces
* Soft CPU Components

---

## Notes

Additional study notes and observations are maintained in:

```text
notes.md
```

Future project ideas and milestones are tracked in:

```text
ProjectsToMake.md
```

---

## Why This Repository?

The purpose of this project is not only to learn Verilog syntax but also to understand how real digital hardware operates.

Rather than jumping directly into FPGA boards, the focus is on mastering simulation, waveform analysis, timing concepts, and hardware thinking before moving to synthesis and deployment on physical devices.

---

## References

* Icarus Verilog
* GTKWave
* IEEE Verilog Standard
* FPGA vendor documentation
* Digital Design and Computer Architecture (Harris & Harris)

---

## Progress

This repository is a work in progress and will continue to grow as new FPGA concepts and projects are explored.
