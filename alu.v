/*
 * alu -- ALU for the 65C02
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 *
 */
module alu( 
    input CI,               // carry in
    input SI,               // shift in
    input [7:0] R,          // input from register file
    input [7:0] M,          // input from memory
    input [4:0] op,         // operation
    output reg [7:0] OUT,   // data out
    output CO               // carry out
);

/*   
 * Calculate temporary result. The 'R' input will be
 * connected to the register file, while the 'M' input
 * comes from memory.
 *
 * This layer can be optimized to single LUT6 per bit
 * on Spartan6, but that most likely requires manual
 * instantiation. 
 *
 * TODO: half carry output
 * 
 * op   function
 * ---  --------
 * 000   R | M      OR 
 * 001   R & M      AND
 * 010   R ^ M      EOR
 * 011   R + M      ADC
 * 100   R + 0      R or INC depending on CI
 * 101   R - 1      R or DEC depending on CI
 * 110   R - M      SBC/CMP
 * 111  ~R & M      TRB
 *
 * NOTE: Carry input is added to each function, so
 * that LUT5 outputs can go through carry chain logic.
 */ 

reg [8:0] temp;

always @(*)
    case( op[2:0] )
        3'b000: temp =  R |  M + CI;
        3'b001: temp =  R &  M + CI;
        3'b010: temp =  R ^  M + CI;
        3'b011: temp =  R +  M + CI;
        3'b100: temp =  R +  0 + CI;
        3'b101: temp =  R + ~0 + CI; 
        3'b110: temp =  R + ~M + CI;
        3'b111: temp = ~R &  M + CI;
    endcase

/*
 * 2nd stage takes previous result, and
 * optionally shifts to left/right, or discards
 * it entirely and replaces it by 'M' input.
 *
 * The shifter function uses dedicated carry 
 * in/out signals.
 *
 * op   function
 * ---  --------
 * 00   temp from above
 * 01   M 
 * 10   shift/rotate left
 * 11   shift/rotate right
 */

always @(*)
    case( op[4:3] )
        2'b00: {CO, OUT} = temp;
        2'b01: {CO, OUT} = { 1'b0, M };
        2'b10: {CO, OUT} = { temp[7:0], SI };
        2'b11: {OUT, CO} = { SI, temp[7:0] };
    endcase

endmodule
