init:
	iverilog -Wall main.v tb.v -o main.vvp
run: init
	vvp main.vvp > debug.log
# 	yosys -p "read_verilog main.v; synth -top mux2x1; show -format png -prefix schematic"
	yosys -p "read_verilog main.v; synth_ice40 -top mux2x1; show -format png -prefix schematic"
sim: run
	gtkwave main.vcd