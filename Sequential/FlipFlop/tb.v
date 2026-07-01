`timescale 1ns/1ps

module dff_tb;

reg clk;
reg d;
wire q;

dff uut (.clk(clk), .d(d), .q(q));

initial
begin
    $dumpfile("main.vcd");
    $dumpvars(0, dff_tb);
end

initial
begin
    $monitor("At time %t, clk = %b, d = %b, q = %b", $time, clk, d, q);

    clk = 0;
    d = 0;

    #10 d = 1;
    #20 d = 0;
    #20 d = 1;
    #20 d = 0;

    #20 $finish;
end

always
begin
    #5 clk = ~clk;
end

endmodule