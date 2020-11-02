/*
 * alu -- ALU for the 65C02
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 *
 * This ALU is divided into 2 stages. The first stage ('adder') 
 * does the logic/arithmetic operations. The second stage ('shifter')
 * optionally shifts the result from the adder by 1 bit position.
 *
 * This module also has all the flag registers, and does the flag
 * updates.
 */
module alu( 
    input clk,              // clk
    input sync,             // opcode sync
    input [7:0] R,          // input from register file
    input [7:0] DB,         // data bus
    input [6:0] op,         // 7-bit operation select
    input [9:0] flag_op,    // 10-bit flag operation select
    input ld_m,             // load enable for M
    input adj_m,            // load BCD adjustment
    output reg V,           // overflow output
    output reg C,           // carry flag
    output reg Z,           // zero flag
    output reg N,           // negative flag
    output reg I,           // interrupt flag
    output reg D,           // decimal flag
    output reg cond,        // condition code 
    output reg [7:0] OUT,   // data out
    output reg CO           // carry out
);

reg [7:0] M;
reg CI, SI;

/*
 * carry in/shift in 
 */
always @(*)
    case( op[1:0] )
        2'b00:          {SI, CI} = 2'b00;
        2'b01:          {SI, CI} = 2'b01;
        2'b10:          {SI, CI} = {C, 1'b0};
        2'b11:          {SI, CI} = {1'b0, C};
    endcase

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

wire [7:0] add;
wire [7:0] carry;

add8_2 #(.INIT(64'h293c668e04c08000)) alu_adder (
    .CI(CI),
    .I0(M),
    .I1(R),
    .op(op[4:2]),
    .O(add),
    .CARRY(carry) );

/*
 * distinguish ADC/SBC, not valid when doing
 * other operations.
 */
wire SBC = op[4];

/*
 * intermediate borrow/carry bits. The number indicates 
 * which bit position the borrow or carry goes into.
 */
wire BC4 = SBC ^ carry[3];
wire BC8 = SBC ^ carry[7];
wire C8 = carry[7];

/*
 * decimal half carry, is set when lower nibble is >= 10
 */
wire DHC = (add[3] & (add[2] | add[1]));

/*
 * decimal carry is set when upper nibble is >= 10
 * and also when upper nibble is 9, and we expect
 * the +6 lower nibble adjustment to generate a carry
 */
wire DC = (add[7] & (add[6] | add[5] | (add[4] & DHC)));

/* 
 * BCD adjust for each of the 2 nibbles
 */
assign adjl = BC4 | DHC;
assign adjh = BC8 | DC;

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
 * 0?---  | unmodified adder result
 * 10---  | adder shift left
 * 11---  | adder shift right
 */

LUT5 #(.INIT(32'hf0ccaaaa)) out0(.O(OUT[0]), .I0(add[0]), .I1(SI),     .I2(add[1]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out1(.O(OUT[1]), .I0(add[1]), .I1(add[0]), .I2(add[2]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out2(.O(OUT[2]), .I0(add[2]), .I1(add[1]), .I2(add[3]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out3(.O(OUT[3]), .I0(add[3]), .I1(add[2]), .I2(add[4]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out4(.O(OUT[4]), .I0(add[4]), .I1(add[3]), .I2(add[5]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out5(.O(OUT[5]), .I0(add[5]), .I1(add[4]), .I2(add[6]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out6(.O(OUT[6]), .I0(add[6]), .I1(add[5]), .I2(add[7]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out7(.O(OUT[7]), .I0(add[7]), .I1(add[6]), .I2(SI),     .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) out8(.O(CO),     .I0(C8),     .I1(add[7]), .I2(add[0]), .I3(op[5]), .I4(op[6]));

/*
 * M register update. The M register holds the most
 * recent data on the bus. It feeds into the ALU, 
 * and also into flag updates.
 */

wire l = adjl;
wire h = adjh;

always @(posedge clk)
    if( sync )
        M <= DB;
    else if( ld_m )
        M <= adj_m ? {1'b0, h, h, 2'b0, l, l, 1'b0 } : DB;

/*
 * update C(arry) flag
 */

wire plp = flag_op[2];

/*
 * the CO1 signal is the ALU carry out, delayed
 * by one cycle. This is because in RMW instructions
 * such as ROL, we do an instruction fetch before 
 * setting the flags, which changes the alu_co.
 */
reg CO1; 

always @(posedge clk)
    CO1 <= CO;

always @(posedge clk)
    if( sync )
        casez( {plp, flag_op[1:0]} )
            3'b001 : C <= CO1;         // delayed ALU carry out 
            3'b010 : C <= CO1 | CO;    // BCD carry
            3'b011 : C <= CO;          // ALU carry out
            3'b10? : C <= M[0];        // PLP
        endcase

/*
 * update N(egative) flag and Z(ero) flag
 *
 * The N/Z flags share two control bits in flags[4:3]
 *
 * 00 - do nothing
 * 01 - BIT (N <= M7, Z <= alu_out)
 * 10 - PLP
 * 11 - N/Z <= alu_out
 *
 */
always @(posedge clk)
    if( sync )
        casez( flag_op[4:3] )
            2'b01 : N <= M[7];         // BIT (bit 7) 
            2'b10 : N <= M[7];         // PLP
            2'b11 : N <= OUT[7];       // ALU N flag 
        endcase

/*
 * update Z(ero) flag
 */
always @(posedge clk)
    if( sync )
        casez( flag_op[4:3] )
            2'b01 : Z <= ~|(R & M);    // BIT  
            2'b10 : Z <= M[1];         // PLP
            2'b11 : Z <= ~|OUT;        // ALU == 0 
        endcase

/*
 * update (o)V(erflow) flag
 *
 */
always @(posedge clk)
    if( sync )
        case( flag_op[8:7] )
            2'b01 : V <= carry[6] ^ carry[7];
            2'b11 : V <= M[6];        // BIT/PLP
        endcase

/*
 * update I(nterrupt) flag and D(ecimal) flags
 *
 * The I/D flags share two control bits in flags[6:5]
 *
 * 00 - do nothing
 * 01 - CLI/SEI
 * 10 - CLD/SED
 * 11 - BRK
 */
always @(posedge clk)
    if( sync )
        casez( {plp, flag_op[6:5]} )
            3'b001 : I <= M[5];         // CLI/SEI 
            3'b011 : I <= 1;            // BRK
            3'b1?? : I <= M[2];         // PLP
        endcase

always @(posedge clk)
    if( sync )
        casez( {plp, flag_op[6:5]} )
            3'b010 : D <= M[5];         // CLD/SED 
          //3'b011 : D <= 0;            // clear D in BRK
            3'b1?0 : D <= M[3];         // PLP
        endcase

/*
 * branch condition. 
 */
always @(*)
    if( M[0] | M[1] | M[2] )  cond = 1;      // non-conditional instructions
    else casez( M[7:4] )
        4'b000?:        cond = ~N;     // BPL
        4'b001?:        cond = N;      // BMI
        4'b010?:        cond = ~V;     // BVC
        4'b011?:        cond = V;      // BVS
        4'b1000:        cond = 1;      // BRA
        4'b100?:        cond = ~C;     // BCC
        4'b101?:        cond = C;      // BCS
        4'b110?:        cond = ~Z;     // BNE
        4'b111?:        cond = Z;      // BEQ
    endcase

endmodule
