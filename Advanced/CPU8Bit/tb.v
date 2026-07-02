module main_tb;
reg clk_in = 0, rst = 1;

wire[4:0] bus_en = {pc_en, mem_en, ir_en, a_en, addsub_en};
reg[7:0] bus;

wire clk, hlt;

wire pc_en, pc_inc;
wire [7:0] pc_out;

wire mem_en, mem_ld;
wire [7:0] mem_out;

wire a_en, a_ld;
wire [7:0] a_out;

wire b_ld;
wire [7:0] b_out;

wire addsub_en, addsub_sub_flag;
wire [7:0] addsub_out;

wire ir_en, ir_ld;
wire [7:0] ir_out;

clk uut_clk(.hlt(hlt), .in(clk_in), .out(clk));
pc uut_pc(.clk(clk), .rst(rst), .inc(pc_inc), .out(pc_out));
memory uut_mem(.clk(clk), .rst(rst), .ld(mem_ld), .bus(bus), .out(mem_out));
register uut_a(.clk(clk), .rst(rst), .ld(a_ld), .bus(bus), .out(a_out));
register uut_b(.clk(clk), .rst(rst), .ld(b_ld), .bus(bus), .out(b_out));
addsub uut_addsub(.a(a_out), .b(b_out), .sub(addsub_sub_flag), .out(addsub_out));
ir uut_ir(.clk(clk), .rst(rst), .ld(ir_ld), .bus(bus), .out(ir_out));
controller uut_controller(.clk(clk), .rst(rst), .opcode(ir_out[7:4]), .out({hlt, pc_inc, pc_en, mem_ld, mem_en, ir_ld, ir_en, a_ld, a_en, b_ld, addsub_sub_flag, addsub_en}));

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main_tb);
    rst = 1; #10 rst = 0;
end

// always #5 clk = ~clk;

always @(*) begin
	case (bus_en)
		5'b00001: bus = addsub_out;
		5'b00010: bus = a_out;
		5'b00100: bus = ir_out;
		5'b01000: bus = mem_out;
		5'b10000: bus = pc_out;
		default: bus = 8'b0;
	endcase
end

integer i;
initial begin
	for (i = 0; i < 128; i++) begin
		#1 clk_in = ~clk_in;
	end
end

always @(posedge clk) begin
    $display(
        "S=%0d PC=%h MEMADDR=%h BUS=%h IRREG=%h IROUT=%h A=%h B=%h | PC_EN=%b PC_INC=%b MEM_EN=%b MEM_LD=%b IR_EN=%b IR_LD=%b A_EN=%b A_LD=%b B_LD=%b ADD_EN=%b SUB=%b HLT=%b T=%0t",
        uut_controller.state,
        uut_pc.pc,
        uut_mem.addr,
        bus,        
        uut_ir.ir,
        ir_out,
        a_out,
        b_out,
        pc_en,
        pc_inc,
        mem_en,
        mem_ld,
        ir_en,
        ir_ld,
        a_en,
        a_ld,
        b_ld,
        addsub_en,
        addsub_sub_flag,
        hlt,
        $time
    );
end

endmodule