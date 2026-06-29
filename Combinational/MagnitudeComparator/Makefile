init:
	iverilog -Wall main.v tb.v -o main.vvp
run: init
	vvp main.vvp > debug.log
	yosys -p "read_verilog main.v; synth -top magcmp; show -format png -prefix schematic"