`timescale 1ns/1ps

module main_tb;

    localparam CLK_FREQ    = 50_000_000;
    localparam BAUDRATE    = 115200;
    localparam CLK_PERIOD  = 20;             // 50 MHz
    localparam BIT_TIME_NS = 8680;           // 1 / 115200

    reg clk;
    reg rst;
    reg en;
    reg rx;

    wire tx;
    wire cts;
    wire rts;

    reg [7:0] data;

    uartmodule #(.CLKMASTER(CLK_FREQ), .BAUDRATE(BAUDRATE)) uut (.clk(clk), .rst(rst), .en(en), .rx(rx), .tx(tx), .cts(cts), .rts(rts));

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
    end

    // Clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // UART TX Task
    task uart_send_byte;

        input [7:0] data;
        integer i;

        begin
            $monitor("RST=%d RX=%d I=%1d INDATA=%b OUTDATA=%b FLAGS=%b", rst, rx, i, data, uut.data, uut.flags);
            // Idle
            rx = 1'b1;
            #(BIT_TIME_NS);
            // Start Bit
            rx = 1'b0;
            #(BIT_TIME_NS);
            // Data Bits (LSB First)
            for(i=0;i<8;i=i+1) begin
                rx = data[i];
                #(BIT_TIME_NS);
            end
            // Stop Bit
            rx = 1'b1;
            #(BIT_TIME_NS);
        end
    endtask

    // Test Sequence
    initial begin
        // $monitor("CLK=%d RST=%d RX=%d INDATA=%d OUTDATA=%d FLAGS=%X", clk, rst, rx, data, uut.data, uut.flags);
        // $monitor("RST=%d RX=%d OUTDATA=%b FLAGS=%b", rst, rx, uut.data, uut.flags);
        uut.enrx = 1'b0;

        rst = 1;
        uut.entx = 1'b1;
        uut.txuut.data = 10'hA4;
        #(CLK_PERIOD);

        rst = 0;
        uut.entx = 1'b0;
        #(10*BIT_TIME_NS);

        rst = 1;
        uut.entx = 1'b1;
        uut.txuut.data = 10'hB8;
        #(CLK_PERIOD);

        rst = 0;
        uut.entx = 1'b0;
        #(10*BIT_TIME_NS);
        
        // #(1000);
        $finish;

        rst = 1;
        en  = 1;
        rx  = 1;

        #(10*CLK_PERIOD);

        rst = 0;

        #(1000);

        $display("-----------------------------");
        $display("Sending 0x55");
        $display("-----------------------------");

        uart_send_byte(8'h55);

        #(5*BIT_TIME_NS);

        $display("-----------------------------");
        $display("Sending 0xA3");
        $display("-----------------------------");

        uart_send_byte(8'hA3);

        #(10*BIT_TIME_NS);

        $finish;

    end
endmodule