/*
 * Right Shift
 * a 8bit, sh 3bit
 */
`default_nettype none
module rightshift(a, sh, o);
    input [7:0] a;
    input [3:0] sh;
    output [7:0] o;

    assign o = a >> sh;

endmodule