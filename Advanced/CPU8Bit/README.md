# SAP-Style 8-bit CPU Architecture

## Overview

This project implements a simple SAP (Simple-As-Possible) inspired 8-bit
CPU in Verilog.

The processor is composed of independent hardware blocks connected
through a shared 8-bit internal bus. A finite-state control unit
generates the control signals that coordinate instruction execution.

                     +------------------+
                     |   Controller     |
                     |  (FSM + Decode)  |
                     +--------+---------+
                              |
                        Control Signals
                              |
    +------+      +-----------+-----------+      +---------+
    |  PC  |----->|                       |<-----|   IR    |
    +------+      |       8-bit BUS       |      +---------+
                  |                       |
    +------+      +-----------+-----------+      +---------+
    |Memory|------------------|----------------->| Register|
    +------+                  |                  |    A    |
                              |                  +---------+
                              |
                              |                  +---------+
                              +----------------->| Register|
                                                 |    B    |
                                                 +---------+
                                                        |
                                                        v
                                                  +-----------+
                                                  | Add/Sub   |
                                                  +-----------+
                                                        |
                                                        +-------> BUS

------------------------------------------------------------------------

## Main Components

### Program Counter (PC)

-   Stores the address of the next instruction.
-   Can increment automatically.
-   Can drive its value onto the internal bus.

------------------------------------------------------------------------

### Memory

The memory has two internal elements:

-   Address Register (MAR)
-   16 × 8-bit ROM/RAM array

During simulation the program is loaded using:

``` verilog
$readmemh("firmwares/main.hex", mem);
```

------------------------------------------------------------------------

### Instruction Register (IR)

The Instruction Register stores the fetched instruction.

Example:

    Instruction = 0x1E

    Opcode  = 0001
    Operand = 1110

The upper nibble contains the opcode.

The lower nibble contains the operand (memory address).

------------------------------------------------------------------------

### Register A

Accumulator.

Stores ALU results and operands.

------------------------------------------------------------------------

### Register B

Temporary register used as the second ALU operand.

------------------------------------------------------------------------

### Add/Sub Unit

Performs

-   Addition
-   Subtraction

```{=html}
<!-- -->
```
    A + B
    A - B

------------------------------------------------------------------------

### Controller

The controller is a finite-state machine (FSM).

Each state generates a control word that enables exactly the hardware
blocks required for that micro-operation.

------------------------------------------------------------------------

## Shared Bus

Only one device may drive the bus at a time.

    PC
    Memory
    IR
    Adder
    Register A
            |
            v
       +------------+
       |   8-bit    |
       |    BUS     |
       +------------+

The bus multiplexer is implemented as:

``` verilog
case(bus_en)
    PC
    Memory
    IR
    Register A
    Adder
endcase
```

------------------------------------------------------------------------

# Instruction Cycle

Each instruction executes in six micro-states.

## State 0 --- Fetch Address

    PC -> BUS -> Memory Address Register

Signals

-   PC_EN
-   MEM_LD

------------------------------------------------------------------------

## State 1 --- Increment PC

    PC = PC + 1

Signals

-   PC_INC

------------------------------------------------------------------------

## State 2 --- Fetch Instruction

    Memory -> BUS -> IR

Signals

-   MEM_EN
-   IR_LD

------------------------------------------------------------------------

## State 3 --- Decode

The controller decodes the opcode stored inside the IR.

Examples

    LDA
    ADD
    SUB
    HLT

------------------------------------------------------------------------

## State 4 --- Fetch Operand

Example:

    LDA 0xD

    Memory[D] -> BUS -> Register A

or

    ADD 0xE

    Memory[E] -> BUS -> Register B

------------------------------------------------------------------------

## State 5 --- Execute

Example ADD

    A = A + B

Example SUB

    A = A - B

------------------------------------------------------------------------

# Example Program

Memory contents

    Address   Data

    0   0D
    1   1E
    2   2F
    3   F0

    D   03
    E   04
    F   02

Assembly

    LDA D
    ADD E
    SUB F
    HLT

Execution

    A = 3
    A = 3 + 4 = 7
    A = 7 - 2 = 5
    HALT

------------------------------------------------------------------------

# Design Characteristics

-   8-bit data bus
-   4-bit address bus
-   FSM-based controller
-   Shared internal bus
-   Separate instruction and execution phases
-   Modular Verilog implementation
-   Program loaded from Intel HEX text using `$readmemh`
-   Easy to extend with new instructions

------------------------------------------------------------------------

# Future Improvements

Possible extensions include:

-   Status Flags (Zero, Carry, Negative)
-   Memory write instructions (STA)
-   Logical operations (AND, OR, XOR)
-   Conditional jumps
-   Stack Pointer
-   CALL / RET
-   Interrupt support
-   Transition to a 32-bit RISC-V architecture
