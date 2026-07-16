init:
	iverilog -Wall rtl/*.v *.v -o main.vvp
run: init
	vvp main.vvp > debug.log
# 	yosys -p "read_verilog rtl/*.v; synth_ice40 -top main; show -format png -prefix schematic"
# 	yosys -p "read_verilog rtl/*.v; synth -top main; show -format png -prefix schematic"
sim: run
	gtkwave main.vcd