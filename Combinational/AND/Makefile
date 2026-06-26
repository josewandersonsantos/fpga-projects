init:
	iverilog main.v tb.v -o sim
	vvp sim
	gtkwave wave.vcd

yosys:
	yosys -p " read_verilog main.v; synth_ice40 -top out; write_json out.json " 