init:
	iverilog -Wall main.v tb.v -o main.vvp

run: init
	vvp main.vvp > debug.log
# 	yosys -p "read_verilog main.v; synth_ice40 -top mux8x1_4b -blif main.blif"
	yosys -p "read_verilog main.v; synth_ice40 -top mux8x1_4b; show -format png -prefix schematic"
sim: run
	gtkwave main.vcd