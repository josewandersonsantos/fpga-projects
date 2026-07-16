module shiftreg(clr, ld, left, right, d, q);
    input clr, ld, left, right;
    input [3:0] d;
    output reg [3:0] q;

    initial begin
        q = 4'b0000;
    end

    always @* begin
        casex ({clr, ld, left, right})
            4'b1xxx: q = 4'b0000;    // Clear
            4'b01xx: q = d;          // Load
            4'b001x: q = q << 1;     // Shift left
            4'b0001: q = q >> 1;     // Shift right
            default: q = q;          // Hold
        endcase
    end
endmodule