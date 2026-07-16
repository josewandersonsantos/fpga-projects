module fsmmoore(clk, rst, x, y);
    input clk, rst, x;
    output reg y;

    reg [1:0] state;

    localparam a = 2'b00,
               b = 2'b01,
               c = 2'b10,
               d = 2'b11;

    initial begin
        state <= a;
    end

    always @(negedge clk, negedge rst) begin
        if (rst == 1'b0) begin
            state <= a;
        end
        else begin
            case(state)
            a: begin
                if (x == 1'b0) state <= b;
                else state <= a;
             end
            b: begin
                if (x == 1'b0) state <= b;
                else state <= c;
             end
            c: begin
                state <= d;
            end
            d: begin
                state <= a;
            end
            endcase
        end
    end

    always @ (state) begin
        case (state)
        a: y = 1'b1;
        b: y = 1'b0;
        c: y = 1'b0;
        d: y = 1'b1;
        endcase
    end
endmodule