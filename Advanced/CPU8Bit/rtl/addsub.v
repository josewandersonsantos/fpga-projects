/*
 * AddSub
 *
 * a   - First 8bit input
 * b   - Second 8bit input
 * sub - Subtract flag
 * out - 8bit output
 *
 */
`default_nettype none
module addsub(a, b, sub, out);
    input [7:0] a, b;
    input sub;
    output [7:0] out;

    assign out = sub ? (a - b) : (a + b);
endmodule