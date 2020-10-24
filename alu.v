/*
 * alu -- ALU for the 65C02
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 *
 * This ALU is divided into 2 stages. The first stage ('adder') 
 * does the logic/arithmetic operations. The second stage ('shifter')
 * optionally shifts the result from the adder by 1 bit position.
 *
 */
module alu( 
    input CI,               // carry in
    input SI,               // shift in
    input [7:0] R,          // input from register file
    input [7:0] M,          // input from memory
    input [4:0] op,         // 5-bit operation select
    output V,               // overflow output
    output adjh,            // BCD adjust needed, high nibble
    output adjl,            // BCD adjust needed, low nibble
    output reg [7:0] OUT,   // data out
    output reg CO           // carry out
);

/*   
 * 1st stage, calculate adder result from the two operands:
 *
 * The 'R' input comes from source register in register file.
 * The 'M' input comes from memory register, holding previous
 * memory read result. This inputs are hard wired, meaning there
 * is no mux on the ALU inputs. 
 *
 * This layer can be optimized to single LUT6 per bit
 * on Spartan6, but that most likely requires manual
 * instantiation. 
 *
 *   op      function
 * ===============================
 * --000  |  R | M      OR 
 * --001  |  R & M      AND
 * --010  |  R ^ M      EOR
 * --011  |  R + M      ADC (also INC/DEC with suitable R)
 * --100  |  R + 0      pass R or INC depending on CI
 * --101  |  R - 1      DEC
 * --110  |  R - M      SBC/CMP
 * --111  | ~R & M      TRB
 *
 * NOTE: Carry input is always added to each function. This
 * is necessary to make it fit in a single LUT. If this is
 * not desired, make sure to set CI=0.
 *
 * Because CI is always added, we need a separate SI input
 * for the 2nd stage shifter, to make sure we can always 
 * set CI=0 while rotating with set carry bit.
 */ 

reg [8:0] adder;

/*
 * 8 bit inverted N (when ~M is used in the expression, 
 * the 9th bit is inverted as well
 */
wire [7:0] N = ~M;

always @(*)
    case( op[2:0] )
        3'b000: adder =  R |  M     + CI;
        3'b001: adder =  R &  M     + CI;
        3'b010: adder =  R ^  M     + CI;
        3'b011: adder =  R +  M     + CI;
        3'b100: adder =  R +  8'h00 + CI;
        3'b101: adder =  R +  8'hff + CI; 
        3'b110: adder =  R +  N     + CI;
        3'b111: adder = ~R &  M     + CI;
    endcase

/*
 * distinguish ADC/SBC, not valid when doing
 * other operations.
 */
wire SBC = op[2];

/*
 * intermediate borrow/carry bits. The number indicates 
 * which bit position the borrow or carry goes into.
 */
wire BC4 = adder[4] ^ R[4] ^ M[4];
wire BC7 = adder[7] ^ R[7] ^ M[7];
wire BC8 = SBC ^ adder[8];

/*
 * overflow
 */
assign V = BC7 ^ BC8;

/* 
 * BCD adjust for each of the 2 nibbles
 */
assign adjl = BC4 | adder[3:1] >= 5;
assign adjh = BC8 | adder[7:5] >= 5 | ((adder[7:4] == 9) & (adder[3:1] >= 5));

/*
 * 2nd stage takes previous result, and
 * optionally shifts to left/right, or discards
 * it entirely and replaces it by 'M' input.
 *
 * Note: the adder carry out will be replaced by
 * the shifter carry out when a shift option is 
 * selected.
 * 
 * op       function
 * ===============================
 * 00---  | unmodified adder result
 * 01---  | bypassed M input
 * 10---  | adder shift left
 * 11---  | adder shift right
 */

always @(*)
    case( op[4:3] )
        2'b00: {CO, OUT} = adder;
        2'b01: {CO, OUT} = { 1'b0, M };
        2'b10: {CO, OUT} = { adder[7:0], SI };
        2'b11: {OUT, CO} = { SI, adder[7:0] };
    endcase

endmodule
