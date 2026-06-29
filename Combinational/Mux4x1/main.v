/*
 * Mux 4 x 1
 */
`default_nettype none
module mux4x1(i0, i1, i2, i3, s0, s1, f);

    input i0, i1, i2, i3, s0, s1;
    output f;

    assign f = i0 & ~s0 & ~s1 | i1 & ~s1 & s0 | i2 & s1 & ~s0 | i3 & s1 & s0;

endmodule