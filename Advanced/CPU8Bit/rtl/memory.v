/*
 * Memory
 *
 * clk - clock signal
 * rst - reset signal, when high, addr is cleared
 * ld  - load signal, when high, addr is loaded with bus value
 * bus - input bus
 * out - output value of memory at addr
 *
 */
`default_nettype none
module memory(clk, rst, ld, bus, out);
    input clk, rst, ld;
    input [7:0] bus;
    output [7:0] out;
    reg [3:0] addr;
    reg [7:0] mem [0:15];

    initial begin
        $readmemh("firmwares/main.hex", mem);

        $display("mem0=%h", mem[0]);
        $display("mem1=%h", mem[1]);
        $display("mem2=%h", mem[2]);
        $display("mem3=%h", mem[3]);
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            addr <= 4'b0000;
        end
        else if (ld) begin
            addr <= bus[3:0];
        end
    end

    assign out = mem[addr];

endmodule