module main_tb;
    reg clk, rst, x;
    wire y;

    fsmmealy uut(.clk(clk), .rst(rst), .x(x), .y(y));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
        clk = 0;
    end

    always #5 clk = ~clk;

    initial begin
        $monitor("CLK=%d RST=%d X=%d Y=%d", clk, rst, x, y);

        rst = 0; #1 rst = 1;

        x = 1'b1; #10
        x = 1'b0; #10
        x = 1'b1; #10
        x = 1'b0; #10
        
        rst = 0; #1 rst = 1;
        x = 1'b1; #10
        x = 1'b0; #10
        x = 1'b1; #10
        x = 1'b0; #10

        $finish;
    end

endmodule