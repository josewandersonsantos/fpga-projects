// `timescale 1ns / 1ps

module main_tb;

    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] s;
    wire cout;

    adder4bit uut (.a(a), .b(b), .cin(cin), .s(s), .cout(cout));
    
    initial begin
        
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);

        $monitor("Time=%0dns | A=%d B=%d Cin=%b | Sum=%d Cout=%b", $time, a, b, cin, s, cout);

        // Case 1: 0 + 0 = 0
        a = 4'b0000; b = 4'b0000; cin = 1'b0;
        #10;

        // Case 2: 5 + 3 = 8
        a = 4'd5;    b = 4'd3;    cin = 1'b0;
        #10;

        // Case 3: 15 + 1 = 16 (make overflow /Cout)
        a = 4'd15;   b = 4'd1;    cin = 1'b0;
        #10;

        // Case 4: 7 + 7 + 1 (Cin) = 15
        a = 4'd7;    b = 4'd7;    cin = 1'b1;
        #10;

        $finish;
    end

endmodule
