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
    output tx, cts, rts;
    reg hwflow;

    wire [9:0] data;
    wire [3:0] flags;

    reg [1:0] maxstopbits, parity;
    reg [3:0] maxdatabits;

    localparam MAXDATABITS8  = 4'b1000,
               MAXDATABITS9  = 4'b1001,
               MAXDATABITS10 = 4'b1010;
    
    localparam PARITYNONE = 2'b00,
               PARITYEVEN = 2'b01,
               PARITYODD  = 2'b10;

    localparam MAXSTOPBITS1 = 2'b01,
               MAXSTOPBITS2 = 2'b10;

    localparam HWFLOWCTRLDIS = 1'b0,
               HWFLOWCTRLEN  = 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            parity      <= PARITYNONE;
            maxstopbits <= MAXSTOPBITS1;
            hwflow      <= HWFLOWCTRLDIS;
            if (parity == PARITYNONE)
                maxdatabits <= MAXDATABITS8;
            else
                maxdatabits <= MAXDATABITS8 + 1;
        end
    end

    uartrx #(.CLK_TICK(CLKMASTER/BAUDRATE)) rxuut (.clk(clk), .rst(rst), .en(en), .rx(rx), .rts(rts), .hwflow(hwflow), .parity(parity), .maxstopbits(maxstopbits), .maxdatabits(maxdatabits), .data(data), .flags(flags));
    // uarttx txuut();

endmodule
