/*
 * Instruction Register
 *
 * clk - clock signal
 * rst - reset signal, when high, ir is cleared
 * ld  - load signal, when high, ir is loaded with bus value
 * bus - input bus
 * out - output value of ir
 *
 */
`default_nettype none
module ir(clk, rst, ld, en, bus, out);
    input clk, rst, ld, en;
    input [7:0] bus;
    output [7:0] out;
    reg [7:0] ir;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            ir <= 8'b00000000;
        end
        else if (ld) begin
            ir <= bus;
        end
    end

    assign out = en ? ir : 8'b0;

endmodule