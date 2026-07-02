/*
 * Clock generator
 *
 * hlt - halt signal, when high, output clock is low
 * in  - input clock
 * out - output clock
 *
 */
`default_nettype none
module clk(hlt, in, out);
    input hlt, in;
    output out;

    assign out = hlt ? 1'b0 : in;
endmodule