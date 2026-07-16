init:
	iverilog -Wall *.v -o main.vvp
run: init
	vvp main.vvp > debug.log
sim: run
	gtkwave main.vcd