/*
 * UART
 * CLKS_PER_BIT = FREQ_CLK / BAUDRATE
 * 434 = 50*10e6 / 1152*10e2 // 50Mhz / 115200
 * 
 * 1 START BIT | N DATA BITS | 0 or 1 PARITY BITS | 1 or 2 STOP BITS
 *
 */
`include "defs.vh"

`default_nettype none
module uartmodule #(parameter CLKMASTER = 50_000_000, parameter BAUDRATE = 115200) (clk, rst, en, rx, tx, cts, rts);
    input clk, rst, en, rx;    
    output tx, cts, rts;
    reg hwflow;

    wire [9:0] data;
    wire [3:0] flags;

    reg [1:0] maxstopbits, parity;
    reg [3:0] maxdatabits;

    always @(posedge clk) begin
        if (rst) begin
            parity      <= `PARITYNONE;
            maxstopbits <= `MAXSTOPBITS1;
            hwflow      <= `HWFLOWCTRLDIS;
            if (parity == `PARITYNONE)
                maxdatabits <= `MAXDATABITS8;
            else
                maxdatabits <= `MAXDATABITS8 + 1;
        end
    end

    uartrx #(.CLK_TICK(CLKMASTER/BAUDRATE)) rxuut (.clk(clk), .rst(rst), .en(en), .rx(rx), .rts(rts), .hwflow(hwflow), .parity(parity), .maxstopbits(maxstopbits), .maxdatabits(maxdatabits), .data(data), .flags(flags));
    uarttx #(.CLK_TICK(CLKMASTER/BAUDRATE)) txuut (.clk(clk), .rst(rst), .en(en), .tx(tx), .cts(cts), .hwflow(hwflow), .parity(parity), .maxstopbits(maxstopbits), .maxdatabits(maxdatabits), .data(data), .flags(flags));
endmodule
