/*
 * UART RX
 */
`default_nettype none
module uartrx(clk, rst, rx, rts);
    input clk, rst, rx;
    reg hwflow;
    reg [2:0] state;
    reg [1:0] countstopbits, maxstopbits, parity;
    reg [9:0] data;
    reg [3:0] flags;
    reg [3:0] countdatabits, counthighbits, maxdatabits;
    output rts;

    localparam STSTARTBIT  = 3'b000,
               STDATABIT   = 3'b001,
               STSTOPBIT   = 3'b010,
               STPARITYBIT = 3'b011,
               STRST       = 3'b111;

    localparam MAXDATABITS8  = 4'b1000,
               MAXDATABITS9  = 4'b1001,
               MAXDATABITS10 = 4'b1010;
    
    localparam PARITYNO   = 2'b00,
               PARITYEVEN = 2'b01,
               PARITYODD  = 2'b10;

    localparam MAXSTOPBITS1 = 2'b01,
               MAXSTOPBITS2 = 2'b10;

    localparam HWFLOWCTRLDIS = 1'b0,
               HWFLOWCTRLEN  = 1'b1;
    
    localparam FLPARITYERR = 3'b001,
               FLSTOPERR   = 3'b010,
               FLDATAREADY = 3'b100;

    initial begin
        state       = STSTARTBIT;
        parity      = PARITYEVEN;
        maxdatabits = MAXDATABITS8;
        maxstopbits = MAXSTOPBITS1;
        hwflow      = HWFLOWCTRLDIS;

        data        = 10'b0;
        countdatabits = 4'b0;
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= STSTARTBIT;
            flags = 4'b0;
            countdatabits = 4'b0;
            countstopbits = 2'b0;
            counthighbits = 4'b0;
        end
        else
            case(state)
            STSTARTBIT:
                if(rx == 1'b0) 
                    state <= STDATABIT;

            STDATABIT: begin            
                data[countdatabits] = rx;
                countdatabits = countdatabits + 1'b1;

                if(rx == 1'b1) 
                    counthighbits = counthighbits + 1'b1;            
                if(countdatabits == maxdatabits) 
                    state <= STSTOPBIT;
            end
            STSTOPBIT: begin
                if(rx == 1'b0) begin
                    flags = flags | FLSTOPERR;
                    state <= STRST;
                end
                countstopbits = countstopbits + 1'b1; 
                if(countstopbits == maxstopbits)
                    state <= STPARITYBIT;
                    // state <= parity ? STPARITYBIT : STRST;
            end
            // Instead to change state, it's better compare in same cycle
            // last bit ?
            STPARITYBIT: begin
                if(parity == PARITYNO)
                    flags = flags | FLDATAREADY;
                else if(parity == PARITYEVEN)
                    if(counthighbits % 2 == 1'b0)
                        flags = flags | FLDATAREADY;
                    else
                        flags = flags | FLPARITYERR;
                else if(parity == PARITYODD)
                    if(counthighbits % 2 == 1'b1)
                        flags = flags | FLDATAREADY;
                    else
                        flags = flags | FLPARITYERR;
                state <= STRST;
            end
            STRST: begin 
                state <= STSTARTBIT;
                flags = 4'b0;
                countdatabits = 4'b0;
                countstopbits = 2'b0;
                counthighbits = 4'b0;
            end
            endcase
    end
endmodule