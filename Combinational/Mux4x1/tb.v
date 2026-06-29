module main_tb;

    reg i0, i1, i2, i3, s0, s1;
    wire f;

    mux4x1 uut(.i0(i0), .i1(i1), .i2(i2), .i3(i3), .s0(s0), .s1(s1), .f(f));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    initial begin
        $monitor("Time=%0dns | I0=%d | I1=%d | I2=%d | I3=%d | S0=%d | S1=%d | F=%d", $time, i0, i1, i2, i3, s0, s1, f);
        
        // Out I0
        s0 = 1'b0; s1 = 1'b0;
        i0 = 1'b1; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #100
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #100

        // Out I1
        s0 = 1'b1; s1 = 1'b0;
        i0 = 1'b0; i1 = 1'b1; i2 = 1'b0; i3 = 1'b0;
        #100
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #100

        // Out I2
        s0 = 1'b0; s1 = 1'b1;
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b1; i3 = 1'b0;
        #100
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #100
        
        // Out I3
        s0 = 1'b1; s1 = 1'b1;
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b0; i3 = 1'b1;
        #100
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #100
        
        $finish;
    end

endmodule