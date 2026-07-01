# RISC V32 by me (In progress..)

riscv32-cpu/
│
├── docs/                  # Documentation, diagrams and notes
│   ├── architecture.md
│   ├── isa.md
│   ├── memory-map.md
│   ├── timing.md
│   ├── datapath.drawio
│   └── control-unit.drawio
│
├── rtl/                   # RTL (Register Transfer Level)
│   │
│   ├── common/
│   │   ├── mux2.v
│   │   ├── mux4.v
│   │   ├── adder.v
│   │   ├── comparator.v
│   │   ├── priority_encoder.v
│   │   ├── decoder.v
│   │   ├── register.v
│   │   ├── counter.v
│   │   └── sign_extend.v
│   │
│   ├── cpu/
│   │   ├── cpu.v
│   │   ├── datapath.v
│   │   ├── control_unit.v
│   │   ├── alu.v
│   │   ├── alu_control.v
│   │   ├── register_file.v
│   │   ├── immediate_generator.v
│   │   ├── instruction_decoder.v
│   │   ├── branch_unit.v
│   │   ├── pc.v
│   │   ├── next_pc.v
│   │   ├── csr.v               # Optional
│   │   └── hazard_unit.v       # Optional (pipeline)
│   │
│   ├── memory/
│   │   ├── rom.v
│   │   ├── ram.v
│   │   ├── dual_port_ram.v
│   │   └── memory_controller.v
│   │
│   ├── bus/
│   │   ├── wishbone_master.v
│   │   └── wishbone_decoder.v
│   │
│   └── peripherals/
│       ├── gpio.v
│       ├── uart_tx.v
│       ├── uart_rx.v
│       ├── uart.v
│       ├── timer.v
│       ├── pwm.v
│       └── spi_master.v
│
├── tb/
│   │
│   ├── common/
│   │   ├── mux_tb.v
│   │   ├── adder_tb.v
│   │   └── register_tb.v
│   │
│   ├── cpu/
│   │   ├── alu_tb.v
│   │   ├── regfile_tb.v
│   │   ├── decoder_tb.v
│   │   ├── branch_tb.v
│   │   ├── cpu_tb.v
│   │   └── integration_tb.v
│   │
│   └── peripherals/
│       ├── uart_tb.v
│       ├── gpio_tb.v
│       └── spi_tb.v
│
├── software/
│   ├── boot/
│   ├── linker/
│   ├── startup.S
│   ├── hello.c
│   ├── fibonacci.c
│   ├── uart_demo.c
│   └── gpio_demo.c
│
├── simulation/
│   ├── run.sh
│   ├── Makefile
│   ├── waves/
│   └── logs/
│
├── synthesis/
│   ├── ice40/
│   ├── ecp5/
│   └── xilinx/
│
├── scripts/
│   ├── build.sh
│   ├── simulate.sh
│   ├── synthesize.sh
│   ├── program_fpga.sh
│   └── clean.sh
│
└── README.md