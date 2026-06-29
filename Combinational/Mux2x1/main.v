/*
 * Mux 2x1 using relational operators
 *
 */
`default_nettype none
module mux2x1(i0, i1, s0, f);
    input i0, i1, s0;
    output f;

    assign f = s0 ? i1 : i0;

endmodule