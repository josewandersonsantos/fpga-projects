module main_tb;

    reg [7:0] bin;
    wire [3:0] h, d, u;

    initial begin 
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    bcd uut(.bin(bin), .h(h), .d(d), .u(u));

    initial begin
        $monitor("BIN=%d, H=%d, D=%d, U=%d", bin, h, d, u);

        bin = 8'd0;
        #10 bin = 8'hA;
        #10 bin = 8'd53;
        #10 bin = 8'd89;
        #10 bin = 8'd121;
        #10 bin = 8'd181;
        #10 bin = 8'd248;
        #10 bin = 8'd255;
        #10
        $finish;
    end
endmodule
