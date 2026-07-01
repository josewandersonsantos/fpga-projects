module main_tb;

    reg clk;
    wire [3:0] q;
    
    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    counter4Bit uut(.clk(clk), .q(q));

    initial begin
        clk = 0;
        repeat (16) @(posedge clk);
        $finish;
    end

    always #5 clk = ~clk;

    always @(posedge clk)
        $display("Time=%0t q=%b", $time, q);

endmodule