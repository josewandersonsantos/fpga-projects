module main_tb;

    reg [7:0] a;
    reg [3:0] sh;
    wire [7:0] o;

    leftshift uut(.a(a), .sh(sh), .o(o));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    initial begin
        $monitor("A=%b | SH=%b | O=%b | Time=%0dns", a, sh, o, $time);

        a = 8'h8; sh = 3'h1; #10
        a = 8'h8; sh = 3'h2; #10
        a = 8'h8; sh = 3'h3; #10

        a = 8'hA; sh = 3'h1; #10
        a = 8'hA; sh = 3'h2; #10
        a = 8'hA; sh = 3'h3; #10

        $finish;
    end


endmodule