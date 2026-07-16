/*
 * Example Arithmetic Logic Unit 8 operations
 *
 * opr == b000 => s = a + b 
 * opr == b001 => s = a - b 
 * opr == b010 => s = a << b 
 * opr == b011 => s = a >> b 
 * opr == b100 => s = a & b 
 * opr == b101 => s = a | b 
 * opr == b110 => s = a ^ b 
 * opr == b111 => s = ~a 
 *  
 */
`default_nettype none
module alu(opr, a, b, s);
    input [2:0] opr;
    input [3:0] a, b;
    output [3:0] s;

    assign s = opr == 3'b000 ? a + b :
               opr == 3'b001 ? a - b :
               opr == 3'b010 ? a << b :
               opr == 3'b011 ? a >> b :
               opr == 3'b100 ? a & b :
               opr == 3'b101 ? a | b :
               opr == 3'b110 ? a ^ b :
               ~a;
endmodule