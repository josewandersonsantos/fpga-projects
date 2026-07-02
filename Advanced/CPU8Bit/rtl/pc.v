/*
 * Program Counter 4-bit
 *
 * clk - clock signal
 * rst - reset signal, when high, pc is cleared
 * inc - increment signal, when high, pc is incremented
 * out - output value of pc
 *
 */
`default_nettype none
module pc(clk, rst, en, inc, out);
    input clk, rst, inc, en;
    output [7:0] out;
    reg [3:0] pc;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            pc <= 4'b0000;
        end
        else if (inc) begin
            pc <= pc + 4'b0001;
        end
    end

    assign out = en ? pc : 8'b0;
endmodule