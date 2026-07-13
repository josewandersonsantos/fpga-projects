/*
 * UART
 * CLKS_PER_BIT = FREQ_CLK / BAUDRATE
 * 434 = 50*10e6 / 1152*10e2 // 50Mhz / 115200
 * 
 * 1 START BIT | N DATA BITS | 0 or 1 PARITY BITS | 1 or 2 STOP BITS
 *
 */
`default_nettype none
module uartmodule #(parameter CLKMASTER = 50_000_000, parameter BAUDRATE = 115200) (clk, rst, en, rx, tx, cts, rts);
    input clk, rst, en, rx;    
    output tx, cts;
    output reg hwflow, rts;

    wire [9:0] data;
    wire [3:0] flags;

    reg [1:0] maxstopbits, parity;
    reg [3:0] maxdatabits;

    localparam MAXDATABITS8  = 4'b1000,
               MAXDATABITS9  = 4'b1001,
               MAXDATABITS10 = 4'b1010;
    
    localparam PARITYNO   = 2'b00,
               PARITYEVEN = 2'b01,
               PARITYODD  = 2'b10;

    localparam MAXSTOPBITS1 = 2'b01,
               MAXSTOPBITS2 = 2'b10;

    localparam HWFLOWCTRLDIS = 1'b0,
               HWFLOWCTRLEN  = 1'b1;

    initial begin
        parity      = PARITYNO;
        maxdatabits = MAXDATABITS8;
        maxdatabits = parity ? maxdatabits + 1 : maxdatabits;
        maxstopbits = MAXSTOPBITS1;
        hwflow      = HWFLOWCTRLDIS;
    end

    uartrx #(.CLK_TICK(CLKMASTER/BAUDRATE)) rxuut (.clk(clk), .rst(rst), .en(en), .rx(rx), .rts(rts), .hwflow(hwflow), .parity(parity), .maxstopbits(maxstopbits), .maxdatabits(maxdatabits), .data(data), .flags(flags));
    // uarttx txuut();

endmodule

`default_nettype none
module uartrx #(parameter CLK_TICK = 434) (clk, rst, en, rx, rts, hwflow, parity, maxstopbits, maxdatabits, data, flags);
    input clk, rst, en, rx;
    reg rx_r, rx_rd;
    
    output reg hwflow, rts;
    output reg [1:0] maxstopbits, parity;
    output reg [3:0] maxdatabits;
    output reg [9:0] data;
    output reg [3:0] flags;
    
    reg [$clog2(CLK_TICK)-1:0] countclk;
    reg [1:0] countstopbits;
    reg [2:0] state;
    reg [3:0] countdatabits, counthighbits;
    
    reg [9:0] datar;

    localparam ST_IDLE      = 3'b000,
               ST_STARTBIT  = 3'b001,
               ST_DATABIT   = 3'b010,
               ST_STOPBIT   = 3'b011,
               ST_PARITYBIT = 3'b100,
               ST_CLEANUP   = 3'b111;
    
    localparam PARITYNO   = 2'b00,
               PARITYEVEN = 2'b01,
               PARITYODD  = 2'b10;

    localparam HWFLOWCTRLDIS = 1'b0,
               HWFLOWCTRLEN  = 1'b1;
    
    localparam FL_PARITYERR = 3'b001,
               FL_STOPERR   = 3'b010,
               FL_DATAREADY = 3'b100;

    initial begin
        state         = ST_IDLE;        
        data          = 10'b0;
        countdatabits = 4'b0;
        countclk      = 0;
        rx_r          = 1'b0;
        rx_rd         = 1'b0;
    end

    always @(posedge clk) begin
        rx_r  <= rx;
        rx_rd <= rx_r;
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= ST_IDLE;
            flags <= 4'b0;
            countdatabits <= 4'b0;
            countstopbits <= 2'b0;
            counthighbits <= 4'b0;
        end
        else
            case(state)
            ST_IDLE: begin
                flags <= 4'b0;
                if(rx_rd == 1'b0)
                    state <= ST_STARTBIT;
                if(hwflow == HWFLOWCTRLEN)
                    rts <= 1'b1;
            end

            ST_STARTBIT: begin
                if (countclk == (CLK_TICK - 1) / 2) begin
                    if(rx_rd == 1'b0) begin
                        state <= ST_DATABIT;
                        countclk <= 1'b0;
                    end
                    else begin
                        state <= ST_IDLE;
                        countclk <= 1'b0;
                    end
                end
                else countclk <= countclk + 1;
            end

            ST_DATABIT: begin
                if (countclk == CLK_TICK) begin
                    datar[countdatabits] <= rx_rd;
                    countdatabits <= countdatabits + 1'b1;

                    if (rx_rd == 1'b1) 
                        counthighbits <= ~counthighbits;
                        
                    if (countdatabits == maxdatabits)
                        state <= ST_STOPBIT;
                    
                    countclk <= 1'b0;
                end
                else countclk <= countclk + 1;
            end

            ST_STOPBIT: begin
                if (countclk == CLK_TICK) begin
                    if(rx_rd == 1'b0) begin
                        flags <= flags | FL_STOPERR;
                        state <= ST_CLEANUP;
                    end
                    countstopbits <= countstopbits + 1'b1; 
                    if(countstopbits == maxstopbits)
                        state <= ST_PARITYBIT;
                        // state <= parity ? ST_PARITYBIT : ST_CLEANUP;
                    
                    countclk <= 1'b0;
                end
                else countclk <= countclk + 1; 
            end

            ST_PARITYBIT: begin
                if(parity == PARITYNO) begin
                    flags <= flags | FL_DATAREADY;
                    data  <= datar;
                end
                else if(parity == PARITYEVEN)
                    if(counthighbits == 1'b0) begin
                        flags <= flags | FL_DATAREADY;
                        data  <= datar;
                    end
                    else
                        flags <= flags | FL_PARITYERR;
                else if(parity == PARITYODD)
                    if(counthighbits == 1'b1) begin
                        flags <= flags | FL_DATAREADY;
                        data  <= datar;
                    end
                    else
                        flags <= flags | FL_PARITYERR;
                state <= ST_CLEANUP;
            end

            ST_CLEANUP: begin
                state <= ST_IDLE;
                // flags <= 4'b0;
                countdatabits <= 4'b0;
                countstopbits <= 2'b0;
                counthighbits <= 4'b0;
            end
            endcase
    end
endmodule