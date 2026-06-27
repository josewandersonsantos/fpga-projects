init:
	iverilog main.v tb.v -o main.vvp
run: init
	vvp main.vvp
	gtkwave main.vcd