init:
	iverilog main.v tb.v ../FullAdder/main.v -o main.vvp
run: init
	vvp main.vvp > debug.log
sim: run
	yosys -p "read_verilog main.v; synth_intel -top adder4bit; show -format png -prefix schematic"
	gtkwave main.vcd
