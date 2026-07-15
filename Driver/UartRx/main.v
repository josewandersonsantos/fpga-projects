/*
 * UART RX
 */
`include "../Uart/defs.vh"

`default_nettype none
module uartrx #(parameter CLK_TICK = 434) (clk, rst, en, rx, rts, hwflow, parity, maxstopbits, maxdatabits, data, flags);
    input clk, rst, en, rx, hwflow;
    input [1:0] maxstopbits, parity;
    input [3:0] maxdatabits;
    
    output reg rts;
    output reg [9:0] data;
    output reg [3:0] flags;
    
    reg rx_r, rx_rd, counthighbits;
    reg [$clog2(CLK_TICK)-1:0] countclk;
    reg [1:0] countstopbits;
    reg [2:0] state;
    reg [3:0] countdatabits;
    reg [9:0] datar;

    localparam ST_IDLE      = 3'b000,
               ST_STARTBIT  = 3'b001,
               ST_DATABIT   = 3'b010,
               ST_STOPBIT   = 3'b011,
               ST_PARITYBIT = 3'b100,
               ST_CLEANUP   = 3'b111;

    always @(posedge clk) begin
        rx_r  <= rx;
        rx_rd <= rx_r;
    end

    always @(posedge clk) begin
        if (rst) begin            
            datar         <= 10'b0;
            data          <= 10'b0;
            countclk      <= 0;
            flags         <= 4'b0;
            countdatabits <= 4'b0;
            countstopbits <= 2'b0;
            counthighbits <= 1'b0;
            state         <= ST_IDLE;
        end
        else
            case(state)
            ST_IDLE: begin                
                if(rx_rd == 1'b0) begin
                    flags <= 4'b0;
                    countclk <= 4'b0;
                    state <= ST_STARTBIT;
                end
                if(hwflow == `HWFLOWCTRLEN)
                    rts <= 1'b1;
            end

            ST_STARTBIT: begin
                if (countclk == (CLK_TICK - 1) / 2) begin
                    countclk <= 1'b0;
                    if(rx_rd == 1'b0)
                        state <= ST_DATABIT;
                    else
                        state <= ST_IDLE;
                end
                else countclk <= countclk + 1;
            end

            ST_DATABIT: begin
                if (countclk == CLK_TICK) begin
                    countclk <= 1'b0;
                    datar[countdatabits] <= rx_rd;
                    countdatabits <= countdatabits + 1'b1;

                    if (rx_rd == 1'b1) 
                        counthighbits <= ~counthighbits;
                        
                    if (countdatabits == maxdatabits)
                        state <= parity == `PARITYNONE ? ST_STOPBIT : ST_PARITYBIT;
                    
                end
                else countclk <= countclk + 1;
            end

            ST_PARITYBIT: begin
                if (countclk == CLK_TICK) begin
                    countclk <= 1'b0;
                
                    if(parity == `PARITYEVEN)
                        if(counthighbits == 1'b0) begin
                            if(counthighbits == rx_rd) begin
                                flags <= flags | `FL_DATAREADY;
                                data  <= datar;
                            end
                            else
                                flags <= flags | `FL_PARITYERR;
                        end
                        else
                            flags <= flags | `FL_PARITYERR;
                    else if(parity == `PARITYODD)
                        if(counthighbits == 1'b1) begin
                            if(counthighbits == rx_rd) begin
                                flags <= flags | `FL_DATAREADY;
                                data  <= datar;
                            end
                            else
                                flags <= flags | `FL_PARITYERR;
                        end
                        else
                            flags <= flags | `FL_PARITYERR;
                    state <= ST_STOPBIT;

                end
                else countclk <= countclk + 1;
            end

            ST_STOPBIT: begin
                if (countclk == CLK_TICK) begin
                    countclk <= 1'b0;
                    if(rx_rd == 1'b0) begin
                        flags <= flags | `FL_STOPERR;
                        state <= ST_CLEANUP;
                    end
                    else begin
                        countstopbits <= countstopbits + 1'b1; 
                        if(countstopbits == maxstopbits)
                            state <= ST_CLEANUP;
                    end
                end
                else countclk <= countclk + 1; 
            end

            ST_CLEANUP: begin
                state <= ST_IDLE;
                datar <= 10'b0;
                countdatabits <= 4'b0;
                countstopbits <= 2'b0;
                counthighbits <= 1'b0;
            end
            endcase
    end
endmodule