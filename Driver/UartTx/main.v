module uarttx(clk, data, tx, cts);
    input clk, rx;
    reg state, parity, data, flow;
    reg [3:0] counter;
    output rts, tx;

    localparam STARTBIT = 2'b00;
               DATABIT  = 2'b00;
               DATABIT  = 2'b00;

    initial begin
        state = STARTBIT;
        counter =4'b0;
    end

    always@(posedge clk, negedge rx) begin
        case(state)



        endcase

    end

endmodule