module main_tb;
    reg clk, rst, x;
    reg [7:0] vlr;
    wire [7:0] tot;

    fsmaccumulator uut (.clk(clk), .rst(rst), .x(x), .vlr(vlr), .tot(tot));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
        clk = 0; vlr = 8'b0; x = 1'b0;
    end

    always #1 clk = ~clk;

    initial begin

        $monitor("CLK=%d, RST=%d, X=%d, ST=%d VLR=%d, TOT=%d", clk, rst, x, uut.state, vlr, tot);

        rst = 1'b0; #1 rst = 1'b1;
        x = 1'b0; vlr = 8'b1010; #2
        x = 1'b1; #2
        x = 1'b0; vlr = 8'b1010; #2
        x = 1'b1; #2
        
        // rst = 1'b0; #1 rst = 1'b1;
        x = 1'b0; vlr = 8'b1010; #2
        x = 1'b1; #2
        x = 1'b0; vlr = 8'b1010; #2
        x = 1'b1; #2

        $finish;

    end

endmodule
