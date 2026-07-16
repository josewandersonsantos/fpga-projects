/*
 * Register
 *
 * clk - clock signal
 * rst - reset signal, when high, register out is cleared
 * ld  - load signal, when high, register out is loaded with bus value
 * bus - input bus
 * out - output value of register out
 *
 */
`default_nettype none
module register(clk, rst, ld, bus, out);
    input clk, rst, ld;
    input [7:0] bus;
    output [7:0] out;
    reg [7:0] reg_out;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            reg_out <= 8'b00000000;
        end
        else if (ld) begin
            reg_out <= bus;
        end
    end

    assign out = reg_out;

endmodule