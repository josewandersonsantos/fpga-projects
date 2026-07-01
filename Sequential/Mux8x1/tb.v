module main_tb;
    reg s0, s1, s2;
    reg [3:0] i0, i1, i2, i3, i4, i5, i6, i7;
    wire [3:0] f;

    mux8x1_4b uut(.i0(i0), .i1(i1), .i2(i2), .i3(i3), .i4(i4), .i5(i5), .i6(i6), .i7(i7), .s0(s0), .s1(s1), .s2(s2), .f(f));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    initial begin
        i0 = 4'b0000; i1 = 4'b0001; i2 = 4'b0010; i3 = 4'b0011;
        i4 = 4'b0100; i5 = 4'b0101; i6 = 4'b0110; i7 = 4'b0111;
        s0 = 0; s1 = 0; s2 = 0;

        // Test all combinations of select lines
        repeat (8) begin
            #10 {s2, s1, s0} = {s2, s1, s0} + 1;
            $display("Time=%0t s=%b f=%b", $time, {s2, s1, s0}, f);
        end
        $finish;
    end

endmodule