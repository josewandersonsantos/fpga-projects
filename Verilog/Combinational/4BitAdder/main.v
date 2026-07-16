/*
 * 4bit Adder
 */
module adder4bit(a, b, cin, s, cout);

    input [3:0] a, b; 
    input cin;
    output [3:0] s; 
    input cout;

    wire c1, c2, c3;

    fulladder fa0(.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .cout(c1));
    fulladder fa1(.a(a[1]), .b(b[1]), .cin(c1), .s(s[1]), .cout(c2));
    fulladder fa2(.a(a[2]), .b(b[2]), .cin(c2), .s(s[2]), .cout(c3));
    fulladder fa3(.a(a[3]), .b(b[3]), .cin(c3), .s(s[3]), .cout(cout));

endmodule