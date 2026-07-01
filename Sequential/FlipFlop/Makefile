init:
	iverilog -Wall main.v tb.v -o main.vvd
run: init
	vvp main.vvd > debug.log
	yosys -p "read_verilog main.v; synth -top dff; show -format png -prefix schematic"
sim: run
	gtkwave main.vcd