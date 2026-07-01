init:
	iverilog -Wall main.v tb.v -o main.vvp
run: init
	vvp main.vvp > debug.log
	yosys -p "read_verilog main.v; synth -top parallelload; show -format png -prefix schematic"
sim: run
	gtkwave main.vcd