/*
 * UART TX
 */
`include "../Uart/defs.vh"

`default_nettype none
module uarttx #(parameter CLK_TICK = 434) (clk, rst, en, tx, cts, hwflow, parity, maxstopbits, maxdatabits, data, flags);
    input clk, rst, en, hwflow;
    input [1:0] maxstopbits, parity;
    input [3:0] maxdatabits;
    
    output reg cts, tx;
    output reg [9:0] data;
    output reg [3:0] flags;
    
    reg tx_r, tx_rd, counthighbits;
    reg [$clog2(CLK_TICK)-1:0] countclk;
    reg [1:0] countstopbits;
    reg [2:0] state;
    reg [3:0] countdatabits;
    reg [9:0] datar;

    localparam ST_IDLE      = 3'b000,
               ST_STARTBIT  = 3'b001,
               ST_DATABIT   = 3'b010,
               ST_PARITYBIT = 3'b011,
               ST_STOPBIT   = 3'b100,
               ST_CLEANUP   = 3'b111;

    always @(posedge clk) begin
        tx_r <= tx_rd;
        tx   <= tx_r;
    end

    always @(posedge clk) begin
        datar <= data;
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= ST_IDLE;
        end

        // if (en) begin

        // end

        else
            case(state)
            ST_IDLE: begin
                state <= ST_STARTBIT;
            end
            ST_STARTBIT: begin
                if (countclk == (CLK_TICK - 1) / 2) begin
                    countclk <= 1'b0;
                    state <= ST_DATABIT;
                end
                else countclk <= countclk + 1;
            end
            ST_DATABIT: begin
                if (countclk == CLK_TICK) begin
                    countclk <= 1'b0;
                    tx_rd <= datar[countdatabits];
                    countdatabits <= countdatabits + 1'b1;

                    if (datar[countdatabits] == 1'b1)
                        counthighbits <= ~counthighbits;

                    if (countdatabits == maxdatabits - 1)
                        state <= parity == `PARITYNONE ? ST_STOPBIT : ST_PARITYBIT;
                end
                else countclk <= countclk + 1;
            end
            ST_PARITYBIT: begin
                if (countclk == CLK_TICK) begin
                    countclk <= 1'b0;
                    
                    if(parity == `PARITYEVEN)
                        if(counthighbits == 1'b0)
                            tx_rd <= 1'b1;
                        else
                            tx_rd <= 1'b0;
                    else if(parity == `PARITYODD)
                        if(counthighbits == 1'b0)
                            tx_rd <= 1'b0;
                        else
                            tx_rd <= 1'b1;
                    
                    state <= ST_STOPBIT;
                end
                else countclk <= countclk + 1;
            end
            ST_STOPBIT: begin
                if (countclk == CLK_TICK) begin
                    countclk <= 1'b0;
                    tx_rd <= 1'b1;

                    countstopbits <= countstopbits + 1'b1; 
                    if(countstopbits == maxstopbits) begin
                        flags <= flags | `FL_DATAREADY;
                        state <= ST_CLEANUP;
                    end
                end
            end
            ST_CLEANUP: begin end
            endcase
    end
endmodule