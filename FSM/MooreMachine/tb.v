module main_tb;
    reg clk, rst, x;
    wire y;

    fsmmoore uut(.clk(clk), .rst(rst), .x(x), .y(y));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
        clk = 0; x = 1;
    end

    always #5 clk = ~clk;

    initial begin
        $monitor ("RST=%d CLK=%d X=%d Y=%d ST=%d", rst, clk, x, y, uut.state);
        rst = 0; #5 rst = 1;
        x = 1;#5
        x = 0;#10
        x = 1;#30
        x = 0;#10
        x = 1;#5
        #20
        $finish;
    end

endmodule