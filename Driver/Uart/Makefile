init:
	iverilog -Wall main.v ../UartRx/main.v ../UartTx/main.v defs.vh tb.v -o main.vvp
run: init
	vvp main.vvp > debug.log
sim: run
	gtkwave main.vcd