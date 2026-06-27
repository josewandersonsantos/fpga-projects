/*
 * Full Summer
 */
module summer(a, b, cin, s, cout);

    input a, b, cin;
    output s, cout;

    wire outOr1, outAnd1, outAnd2;

    xor xor1(outOr1, a, b);
    xor xor2(s, outOr1, cin);
    and and1(outAnd1, outOr1, cin);
    and and2(outAnd2, a, b);
    or or3(cout, outAnd1, outAnd2);

endmodule