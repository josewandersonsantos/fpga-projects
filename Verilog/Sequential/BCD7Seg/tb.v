module main_tb;
    reg [3:0] in;
    wire a, b, c, d, e, f, g;

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    bcd7seg uut(.in(in), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g));

    initial begin
        in = 4'b0000;
        // $monitor("Time: %0t | Input: %b | Output: a=%b b=%b c=%b d=%b e=%b f=%b g=%b", $time, in, a, b, c, d, e, f, g);
        $monitor("Input: %b | Output: a=%b b=%b c=%b d=%b e=%b f=%b g=%b | Time: %0t", in, a, b, c, d, e, f, g, $time);
        repeat(10) begin
            #10 in = in + 1;
        end
    end

endmodule