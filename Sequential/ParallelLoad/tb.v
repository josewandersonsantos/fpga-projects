module main_tb;

    reg [3:0] d;
    reg clk, ld;
    wire [3:0] q;

    parallelload uut (.d(d), .clk(clk), .ld(ld), .q(q));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
        clk = 1'b0; d = 4'b0000; ld = 1'b0;
    end

    initial begin
        $monitor("Input: %b | Output: %b | Time: %0t", d, q, $time);
        repeat(10) begin
            #10 d = d + 1; ld = ~ld;
        end
        $finish;
    end

    always #5 clk = ~clk;    

endmodule