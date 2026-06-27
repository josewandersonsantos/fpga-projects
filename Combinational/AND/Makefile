init:
	iverilog main.v tb.v -o main.vvp
	vvp main.vvp
	gtkwave main.vcd

yosys:
	yosys -p " read_verilog main.v; synth_ice40 -top out; write_json out.json " 