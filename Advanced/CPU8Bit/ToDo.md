# CPU 8 BITS

cpu_8bit_top          ← Main (top)
├── control_unit      ← Control unit (FSM)
├── datapath          ← Data path
│   ├── register_file
│   ├── alu
│   ├── pc (Program Counter)
│   ├── instruction_register
│   ├── flags_register
│   └── muxes / buffers
├── memory_controller (optional)
└── decoder           ← Can be inside in control unit
