module parallelload(clk, ld, d, q);
    input [3:0] d;
    input clk, ld;
    output reg [3:0] q;

    initial begin
        q = 4'b0000;
    end

    always @(negedge clk) begin
        if (ld == 1'b1)
            q <= d;
    end
endmodule