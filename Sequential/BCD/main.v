/*
 * Binary converter to decimal 3 digits
 */
`default_nettype none
module bcd(bin, h, d, u);
    input [7:0] bin;
    output reg [3:0] h, d, u;

    integer i;

    always @* begin
        h = 4'b0000;
        d = 4'b0000;
        u = 4'b0000;

        // if (bin >= 100) begin
        //     h = bin / 100;
        //     d = (bin % 100) / 10;
        //     u = bin % 10;
        // end else if (bin >= 10) begin
        //     d = bin / 10;
        //     u = bin % 10;
        // end else begin
        //     u = bin;
        // end

        for(i=7; i>=0; i=i-1) begin
            // Adjust BCD values if they are greater than or equal to 5
            if (h >= 5) h = h + 3;
            if (d >= 5) d = d + 3;
            if (u >= 5) u = u + 3;

            h = h << 1;
            h[0] = d[3];
            
            d = d << 1;
            d[0] = u[3];
            
            u = u << 1;

            // Add the next bit of the binary number to the units place
            u[0] = bin[i];
        end
    end
endmodule