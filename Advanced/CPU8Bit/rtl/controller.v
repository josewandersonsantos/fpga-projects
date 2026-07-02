/*
 * Controller for 8bit CPU
 *
 * clk - clock signal
 * rst - reset signal, when high, state is cleared
 * opcode - input opcode from instruction register
 * out - output control word
 */
`default_nettype none
module controller(clk, rst, opcode, out);
    input clk, rst;
    input [3:0] opcode;
    output [11:0] out;

    reg [2:0] state;
    reg [11:0] ctrl_word;

    /*
     * State transition
     */
    localparam SIG_HLT       = 11;
    localparam SIG_PC_INC    = 10;
    localparam SIG_PC_EN     = 9;
    localparam SIG_MEM_LD    = 8;
    localparam SIG_MEM_EN    = 7;
    localparam SIG_IR_LD     = 6;
    localparam SIG_IR_EN     = 5;
    localparam SIG_A_LD      = 4;
    localparam SIG_A_EN      = 3;
    localparam SIG_B_LD      = 2;
    localparam SIG_ADDER_SUB = 1;
    localparam SIG_ADDER_EN  = 0;

    localparam OP_LDA = 4'b0000;
    localparam OP_ADD = 4'b0001;
    localparam OP_SUB = 4'b0010;
    localparam OP_HLT = 4'b1111;

    // State machine
    always @(negedge clk, posedge rst) begin
        if (rst) begin
            state <= 0;
        end 
        else if (state == 3'd5) begin
            state <= 3'b000;
        end 
        else begin
            state <= state + 3'b001;
        end        
    end

    always @(*) begin
        ctrl_word = 12'b0;
        case (state)
        /*
         * State 0: Put PC to BUS and load to MEM
         */
        3'b000: begin
            ctrl_word[SIG_PC_EN]  = 1'b1;
            ctrl_word[SIG_MEM_LD] = 1'b1;
        end
        /*
         * State 1: Increment PC
         */
        3'b001: begin
            ctrl_word[SIG_PC_INC] = 1'b1;
        end
        /*
         * State 2: Load data from memory to BUS and load to IR
         */
        3'b010: begin
            ctrl_word[SIG_MEM_EN] = 1'b1;
            ctrl_word[SIG_IR_LD]  = 1'b1;
        end
        /*
         * State 3: Decode instruction
         */
        3'b011: begin
            case (opcode)
                OP_LDA, OP_ADD, OP_SUB: begin
                    ctrl_word[SIG_IR_EN]  = 1'b1;
                    ctrl_word[SIG_MEM_LD] = 1'b1;
                end
                OP_HLT: begin
                    ctrl_word[SIG_HLT] = 1'b1;
                end
            endcase
        end
        /*
         * State 4: Load data from memory to BUS and load to A or B
         */
        3'b100: begin
            case (opcode)
                OP_LDA: begin
                    ctrl_word[SIG_MEM_EN] = 1'b1;
                    ctrl_word[SIG_A_LD]   = 1'b1;
                end
                OP_ADD, OP_SUB: begin
                    ctrl_word[SIG_MEM_EN] = 1'b1;
                    ctrl_word[SIG_B_LD]   = 1'b1;
                end
            endcase
        end
        /*
         * State 5: Perform operation
         */
        3'b101: begin
            case (opcode)
                OP_ADD: begin
                    ctrl_word[SIG_ADDER_EN] = 1'b1;
                    ctrl_word[SIG_A_LD]     = 1'b1;
                end
                OP_SUB: begin
                    ctrl_word[SIG_ADDER_EN]  = 1'b1;
                    ctrl_word[SIG_ADDER_SUB] = 1'b1;
                    ctrl_word[SIG_A_LD]      = 1'b1;
                end
            endcase
        end
        endcase
    end

    assign out = ctrl_word;

endmodule