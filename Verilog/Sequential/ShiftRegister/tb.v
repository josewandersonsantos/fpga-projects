module main_tb;

    reg clr, ld, left, right;
    reg [3:0] d;
    wire [3:0] q;

    shiftreg uut (.clr(clr), .ld(ld), .left(left), .right(right), .d(d), .q(q));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end
    
    initial begin
        clr = 0; ld = 0; left = 0; right = 0; d = 4'b0000;
        // Test clear
        #10 clr = 1; #10 clr = 0;
        // Test load
        #10 ld = 1; d = 4'b1010; #10 ld = 0;
        // Test shift left
        #10 left = 1; #10 left = 0;
        // Test shift right
        #10 right = 1; #10 right = 0;
        // Test hold
        #10;
        $finish;
    end
endmodule