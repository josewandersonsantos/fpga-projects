/*
 * Main module for 8bit CPU
 */
`default_nettype none
module main(clk_in, rst_in);
    input wire clk_in, rst_in;

    wire clk, hlt;
    wire rst = rst_in;
    
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
    
    reg [7:0] bus;
    wire [4:0] bus_en = {pc_en, mem_en, ir_en, a_en, addsub_en};

    clk uut_clk(.hlt(hlt), .in(clk_in), .out(clk));
    pc uut_pc(.clk(clk), .rst(rst), .inc(pc_inc), .out(pc_out));
    memory uut_mem(.clk(clk), .rst(rst), .ld(mem_ld), .bus(bus), .out(mem_out));
    register uut_a(.clk(clk), .rst(rst), .ld(a_ld), .bus(bus), .out(a_out));
    register uut_b(.clk(clk), .rst(rst), .ld(b_ld), .bus(bus), .out(b_out));
    addsub uut_addsub(.a(a_out), .b(b_out), .sub(addsub_sub_flag), .out(addsub_out));
    ir uut_ir(.clk(clk), .rst(rst), .ld(ir_ld), .bus(bus), .out(ir_out));
    controller uut_controller(.clk(clk), .rst(rst), .opcode(ir_out[7:4]), .out({hlt, pc_inc, pc_en, mem_ld, mem_en, ir_ld, ir_en, a_ld, a_en, b_ld, addsub_sub_flag, addsub_en}));

    // assign bus = (pc_en)    ? pc_out    :
    //              (mem_en)   ? mem_out   :
    //              (a_en)     ? a_out     :
    //              (addsub_en)? addsub_out:
    //              (ir_en)    ? ir_out    : 8'b0;

    always @(*) begin
        case (bus_en)
            5'b00001: bus = addsub_out;
            5'b00010: bus = a_out;
            5'b00100: bus = ir_out;
            5'b01000: bus = mem_out;
            5'b10000: bus = pc_out;
            default : bus = 8'b00;
        endcase
    end
endmodule