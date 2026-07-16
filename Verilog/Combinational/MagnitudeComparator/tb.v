`default_nettype none
module main_tb;

    reg [3:0] a, b;
    wire aeqb, agtb, altb;
    magcmp uut(.a(a), .b(b), .aeqb(aeqb), .agtb(agtb), .altb(altb));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    initial begin

        $monitor("Time=%0dns | A=%d B=%d AeqB=%b | AgtB=%d AltB=%b", $time, a, b, aeqb, agtb, altb);
        
        a = 4'b1111; b = 4'b1111; #100
        a = 4'b1111; b = 4'b0111; #100
        a = 4'b0111; b = 4'b1111; #100

        $display("Finish.");
        $finish;
    end

endmodule