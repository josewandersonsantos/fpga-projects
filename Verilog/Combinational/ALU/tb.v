module main_tb;
    reg [3:0] a, b;
    reg [2:0] opr;
    wire [3:0] s;

    alu uut(.a(a), .b(b), .opr(opr), .s(s));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end
    
    initial begin
        $monitor("A=%b B=%b OPR=%b S=%d Time=%0dns", a, b, opr, s, $time);

        opr = 3'b000;
        a = 4'd10; b = 4'd5;
        #10;

        opr = 3'b001;
        #10;

        opr = 3'b010;
        a = 4'd10; b = 4'd2;
        #10;
        
        opr = 3'b011;
        #10;

        opr = 3'b100;
        a = 4'd9; b = 4'd7;
        #10;
        
        opr = 3'b101;
        #10;

        opr = 3'b110;
        #10;

        opr = 3'b111;
        a = 4'b1111;
        #10;

        $finish;
    end

endmodule