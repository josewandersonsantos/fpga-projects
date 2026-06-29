module main_tb;

    reg a0, a1, a2, a3;
    wire p;

    paritygeneven uut(.a0(a0), .a1(a1), .a2(a2), .a3(a3), .p(p));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end
    
    initial begin
        $monitor("A0=%d | A1=%d | A2=%d | A3=%d | P=%d | Time%0dns", a0, a1, a2, a3, p, $time);

        a0=1'b0; a1=1'b0; a2=1'b0; a3='b0;
        #10
        a0=1'b1; a1=1'b0; a2=1'b0; a3='b0;
        #10
        a0=1'b0; a1=1'b1; a2=1'b0; a3='b0;
        #10
        a0=1'b1; a1=1'b1; a2=1'b0; a3='b0;
        #10
        a0=1'b0; a1=1'b0; a2=1'b1; a3='b0;
        #10
        a0=1'b1; a1=1'b0; a2=1'b1; a3='b0;
        #10
        a0=1'b1; a1=1'b1; a2=1'b0; a3='b0;
        #10
        a0=1'b1; a1=1'b1; a2=1'b1; a3='b0;
        #10
        a0=1'b0; a1=1'b0; a2=1'b0; a3='b1;
        #10
        a0=1'b1; a1=1'b0; a2=1'b0; a3='b1;
        #10
        a0=1'b0; a1=1'b1; a2=1'b0; a3='b1;
        #10
        a0=1'b1; a1=1'b1; a2=1'b0; a3='b1;
        #10
        a0=1'b0; a1=1'b0; a2=1'b1; a3='b1;
        #10
        a0=1'b1; a1=1'b0; a2=1'b1; a3='b1;
        #10
        a0=1'b0; a1=1'b1; a2=1'b1; a3='b1;
        #10
        a0=1'b1; a1=1'b1; a2=1'b1; a3='b1;
        #10

        $finish;
    end

endmodule