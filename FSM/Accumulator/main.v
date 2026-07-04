`default_nettype none
module fsmaccumulator(clk, rst, x, vlr, tot);
    input clk, rst, x;
    input [7:0] vlr;
    output reg [7:0] tot;
    
    reg [1:0] state;
    localparam START = 2'b00;
    localparam WAIT  = 2'b01;
    localparam SUM   = 2'b10;
    localparam WAIT2 = 2'b11;

    initial begin
        state <= START;
        // tot <= 8'b0;
    end

    always @(posedge clk, negedge rst) begin
        
        if (rst == 1'b0) begin
            tot = 8'b0;
            state <= START;
        end

        case (state)
            START: begin
                tot = 8'b0;
                state <= WAIT;
            end
            WAIT: if (x == 1'b0) state <= SUM;
            SUM: begin
                tot = tot + vlr;
                state <= WAIT2;
            end
            WAIT2: begin
                if (x == 1'b0) state <= WAIT;
            end
        
        endcase
    end

endmodule
