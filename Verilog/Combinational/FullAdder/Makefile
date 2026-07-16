init:
	iverilog main.v tb.v -o main.vvp
run: init
	vvp main.vvp
	gtkwave main.vcd

png:
	yosys -p "read_verilog main.v; synth -top fulladder; show -format png -prefix schematic"
