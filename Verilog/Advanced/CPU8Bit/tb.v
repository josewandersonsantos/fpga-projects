`default_nettype none

module main_tb;

reg clk_in = 0;
reg rst = 1;

main uut(.clk_in(clk_in), .rst_in(rst));

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main_tb);

    #10 rst = 0;

    #500

    $finish;
end

always #1 clk_in = ~clk_in;

always @(posedge uut.clk) begin

    $display(
        "S=%0d PC=%h MEMADDR=%h BUS=%h IRREG=%h IROUT=%h A=%h B=%h | PC_EN=%b PC_INC=%b MEM_EN=%b MEM_LD=%b IR_EN=%b IR_LD=%b A_EN=%b A_LD=%b B_LD=%b ADD_EN=%b SUB=%b HLT=%b T=%0t",

        uut.uut_controller.state,
        uut.uut_pc.pc,
        uut.uut_mem.addr,

        uut.bus,

        uut.uut_ir.ir,
        uut.ir_out,

        uut.a_out,
        uut.b_out,

        uut.pc_en,
        uut.pc_inc,
        uut.mem_en,
        uut.mem_ld,
        uut.ir_en,
        uut.ir_ld,
        uut.a_en,
        uut.a_ld,
        uut.b_ld,
        uut.addsub_en,
        uut.addsub_sub_flag,
        uut.hlt,

        $time
    );

end

endmodule