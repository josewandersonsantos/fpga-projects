// `timescale 1ns/1ps

module main_tb;

    reg a_tb, b_tb, cin_tb;
    wire s_tb, cout_tb;

    fulladder uut(.a(a_tb), .b(b_tb), .cin(cin_tb), .s(s_tb), .cout(cout_tb));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    initial begin
    
        a_tb = 0; b_tb = 0; cin_tb = 0;
        #10
        a_tb = 0; b_tb = 0; cin_tb = 1;
        #10
        a_tb = 0; b_tb = 1; cin_tb = 0;
        #10
        a_tb = 0; b_tb = 1; cin_tb = 1;
        #10
        a_tb = 1; b_tb = 0; cin_tb = 0;
        #10
        a_tb = 1; b_tb = 0; cin_tb = 1;
        #10
        a_tb = 1; b_tb = 1; cin_tb = 0;
        #10
        a_tb = 1; b_tb = 1; cin_tb = 1;
        #10
        
    $display("Finish.");
    $finish;
    end

endmodule