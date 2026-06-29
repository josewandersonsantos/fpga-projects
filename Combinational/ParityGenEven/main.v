`default_nettype none
module paritygeneven(a0, a1, a2, a3, p);
    input a0, a1, a2, a3;
    output p;

    assign p = a0 ^ a1 ^ a2 ^ a3;

endmodule