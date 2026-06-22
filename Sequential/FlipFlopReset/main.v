module dff (input wire clk, input wire d, input wire rst, output reg q);

always @(posedge clk)
begin
    if (rst)
        q <= 0;
    else
        q <= d;
end

endmodule