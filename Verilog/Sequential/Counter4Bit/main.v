module counter4Bit(clk, q);
    input clk;
    output reg [3:0] q;

    initial begin
        q = 4'b0000;
    end

    always @(posedge clk) begin
        q <= q + 4'b0001;
    end
endmodule