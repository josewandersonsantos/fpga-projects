init:
	iverilog main.v tb.v ../FullAdder/main.v -o main.vvp
run: init
	vvp main.vvp > debug.log
	gtkwave main.vcd
