init:
	iverilog -Wall main.v -o main.vvp
run: init
	vvp main.vvp > debug.log
sim: run
	gtkwave main.vcd