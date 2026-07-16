module main_tb;

    reg i0, i1, s0;
    wire f;

    mux2x1 uut(.i0(i0), .i1(i1), .s0(s0), .f(f));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    initial begin
        
        $monitor("S0=%d I0=%d I1=%d F=%d Time=%0dns", s0, i0, i1, f, $time);

        s0 = 1'b0;
        i0 = 1'b1; i1 = 1'b0;
        #10
        i0 = 1'b0; i1 = 1'b1;
        #10
        
        s0 = 1'b1;
        i0 = 1'b0; i1 = 1'b1;
        #10
        i0 = 1'b1; i1 = 1'b0;
        #10

        $finish;
    end

endmodule