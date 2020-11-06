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
    input rdy,              // RDY input
    input sync,             // opcode sync
    input [7:0] R,          // input from register file
    input [7:0] DB,         // data bus
    input [6:0] op,         // 7-bit operation select
    input [9:0] flag_op,    // 10-bit flag operation select
    input ld_m,             // load enable for M
    input adj_m,            // load BCD adjustment
    input B,                // BRK flag
    output mask_irq,        // one cycle early I flag notification 
    output [7:0] P,         // flags register
    output cond,            // condition code 
    output [7:0] OUT,       // data out
    output CO               // carry out
);

wire [7:0] M;
wire [7:0] AI = R;          // A input of ALU
wire [7:0] BI;              // B input of ALU
wire CI, SI;                // carry in/shift in

wire C, N, V, I, D, Z;
assign P = { N, V, 1'b1, B, D, I, Z, C };

/*
 * carry in/shift in 
 * 
 * op[1:0]| SI  CI
 * =======|========
 *   00   | 0   0
 *   01   | 0   1
 *   10   | C   0
 *   11   | 0   C
 */

LUT3 #(.INIT(8'h8c)) ci(.O(CI), .I0(C), .I1(op[0]), .I2(op[1]));
LUT3 #(.INIT(8'h20)) si(.O(SI), .I0(C), .I1(op[0]), .I2(op[1]));

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
    .I0(BI),
    .I1(AI),
    .op(op[4:2]),
    .O(add),
    .CARRY(carry) );

/*
 * carry out bit
 */
wire C8 = carry[7];
wire C7 = carry[6];


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

LUT5 #(.INIT(32'hf0ccaaaa)) shift0(.O(OUT[0]), .I0(add[0]), .I1(SI),     .I2(add[1]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift1(.O(OUT[1]), .I0(add[1]), .I1(add[0]), .I2(add[2]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift2(.O(OUT[2]), .I0(add[2]), .I1(add[1]), .I2(add[3]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift3(.O(OUT[3]), .I0(add[3]), .I1(add[2]), .I2(add[4]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift4(.O(OUT[4]), .I0(add[4]), .I1(add[3]), .I2(add[5]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift5(.O(OUT[5]), .I0(add[5]), .I1(add[4]), .I2(add[6]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift6(.O(OUT[6]), .I0(add[6]), .I1(add[5]), .I2(add[7]), .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift7(.O(OUT[7]), .I0(add[7]), .I1(add[6]), .I2(SI),     .I3(op[5]), .I4(op[6]));
LUT5 #(.INIT(32'hf0ccaaaa)) shift8(.O(CO),     .I0(C8),     .I1(add[7]), .I2(add[0]), .I3(op[5]), .I4(op[6]));

/*
 * z0 indicates if OUT[6:1] == 0.
 * z1 indicates if OUT[0] and OUT[7] are both 0.
 *
 * both are calculated based on 'add' going into the shifter.
 */
wire z0, z1;

LUT6 #(.INIT(64'h00000001)) lut_z0( .O(z0), .I0(add[1]), .I1(add[2]), .I2(add[3]), .I3(add[4]), .I4(add[5]), .I5(add[6]) );
LUT5 #(.INIT(32'h03051111)) lut_z1( .O(z1), .I0(add[0]), .I1(add[7]), .I2(SI),     .I3(op[5]),  .I4(op[6]) );

/*
 * distinguish ADC/SBC, not valid when doing
 * other operations.
 */
wire SBC = op[4];

wire adjl, adjh;

// LUT5 for BCD adjust lower nibble
// calculates: BC4 | (add[3:1] >= 5)
LUT6 #(.INIT(64'hffe0e0ffe0ffffe0)) lut_adjl( .O(adjl), .I0(add[1]), .I1(add[2]), .I2(add[3]), .I3(add[4]), .I4(AI[4]), .I5(BI[4]) );

// LUT6 for BCD adjust higher nibble
// calculates: (add[6] | add[5] | (add[4] & (add[3:1] >= 5))))
// note, partial logic, still needs to be combined with add[7], C8 and SBC
LUT6 #(.INIT(64'hffffffffffffe000)) lut_adjh( .O(adjh), .I0(add[1]), .I1(add[2]), .I2(add[3]), .I3(add[4]), .I4(add[5]), .I5(add[6]) );

/*
 * BI register update. The BI register usually holds the most
 * recent data on the bus, but it's also used to hold BCD
 * adjustment terms.
 */

wire BI0, BI3, BI4, BI7;
wire BI1, BI2, BI5, BI6;

// The BI bits 0,3,4,7 are equal to zero when doing BCD adjust, or DB otherwise
// Keep all LUT inputs the same so they can be packed.
LUT5 #(.INIT(32'h44444444)) lut_bi0( .O(BI0), .I0(adj_m), .I1(DB[0]), .I2(DB[3]), .I3(DB[4]), .I4(DB[7]) );
LUT5 #(.INIT(32'h50505050)) lut_bi3( .O(BI3), .I0(adj_m), .I1(DB[0]), .I2(DB[3]), .I3(DB[4]), .I4(DB[7]) );
LUT5 #(.INIT(32'h55005500)) lut_bi4( .O(BI4), .I0(adj_m), .I1(DB[0]), .I2(DB[3]), .I3(DB[4]), .I4(DB[7]) );
LUT5 #(.INIT(32'h55550000)) lut_bi7( .O(BI7), .I0(adj_m), .I1(DB[0]), .I2(DB[3]), .I3(DB[4]), .I4(DB[7]) );

// The BI bits 1 and 2 are equal to 'adjl' when doing BCD adjust, or DB otherwise 
// Keep all LUT inputs the same so they can be packed.
LUT5 #(.INIT(32'hd8d8d8d8)) lut_bi1( .O(BI1), .I0(adj_m), .I1(adjl), .I2(DB[1]), .I3(DB[2]), .I4(x) );
LUT5 #(.INIT(32'hdd88dd88)) lut_bi2( .O(BI2), .I0(adj_m), .I1(adjl), .I2(DB[1]), .I3(DB[2]), .I4(x) );

// The BI bits 5 and 6 are equal to '(adjh & add[7]) | (SBC ^ C8)' when doing BCD, or DB otherwise
LUT6 #(.INIT(64'he444eeee_eeeee444)) lut_bi5( .O(BI5), .I0(adj_m), .I1(DB[5]), .I2(adjh), .I3(add[7]), .I4(C8), .I5(SBC) );
LUT6 #(.INIT(64'he444eeee_eeeee444)) lut_bi6( .O(BI6), .I0(adj_m), .I1(DB[6]), .I2(adjh), .I3(add[7]), .I4(C8), .I5(SBC) );

reg8 bi_reg( 
    .clk(clk),
    .EN(ld_m),
    .RST(1'b0),
    .D({BI7, BI6, BI5, BI4, BI3, BI2, BI1, BI0}),
    .Q(BI) );

/*
 * M register update. The M register holds a copy of the
 * DB value.
 */
reg8 m_reg( 
    .clk(clk),
    .EN(ld_m),
    .RST(1'b0),
    .D(DB),
    .Q(M) );

/*
 * the CO1 signal is the ALU carry out, delayed
 * by one cycle. This is needed for the BCD operations
 * because a carry can occur in the main cycle, or in
 * the adjust cycle.
 */
wire CO1; 
FDRE co1( .C(clk), .CE(rdy), .R(1'b0), .D(CO), .Q(CO1) );

/*
 * flag updates
 */

wire c_flag, n_flag, z_flag, v_flag, i_flag, d_flag;

// flag update logic
LUT6 #(.INIT(64'hccfcf0aaaaaaaaaa)) lut_c( .O(c_flag), .I0(C),  .I1(CO),   .I2(CO1),    .I3(flag_op[0]), .I4(flag_op[1]), .I5(sync) );
LUT6 #(.INIT(64'hf0ccccaaaaaaaaaa)) lut_n( .O(n_flag), .I0(N),  .I1(M[7]), .I2(OUT[7]), .I3(flag_op[3]), .I4(flag_op[4]), .I5(sync) );
LUT6 #(.INIT(64'hff88f0ff0088f000)) lut_z( .O(z_flag), .I0(z0), .I1(z1),   .I2(M[1]),   .I3(flag_op[2]), .I4(flag_op[9]), .I5(Z) );
LUT6 #(.INIT(64'hccccaaaa0ff0aaaa)) lut_v( .O(v_flag), .I0(V),  .I1(M[6]), .I2(C7),     .I3(C8),         .I4(flag_op[7]), .I5(flag_op[8]) );
LUT6 #(.INIT(64'hccccccccffaaf0aa)) lut_i( .O(i_flag), .I0(I),  .I1(M[2]), .I2(M[5]),   .I3(flag_op[5]), .I4(flag_op[6]), .I5(flag_op[2]) );
LUT6 #(.INIT(64'hcccccccc00f0aaaa)) lut_d( .O(d_flag), .I0(D),  .I1(M[3]), .I2(M[5]),   .I3(flag_op[5]), .I4(flag_op[6]), .I5(flag_op[2]) );

// registers
FDRE c( .C(clk), .CE(rdy),  .R(1'b0), .D(c_flag), .Q(C) );
FDRE n( .C(clk), .CE(rdy),  .R(1'b0), .D(n_flag), .Q(N) );
FDRE z( .C(clk), .CE(sync), .R(1'b0), .D(z_flag), .Q(Z) );
FDRE v( .C(clk), .CE(sync), .R(1'b0), .D(v_flag), .Q(V) );
FDRE i( .C(clk), .CE(sync), .R(1'b0), .D(i_flag), .Q(I) );
FDRE d( .C(clk), .CE(sync), .R(1'b0), .D(d_flag), .Q(D) );

/*
 * masking IRQs is decided based on next I flag value, and not state of flop
 * to avoid problem with nested interrupts.
 */
assign mask_irq = i_flag;

/*
 * branch condition evaluation
 */
wire flag_set;                          // is conditional flag set ? can be inverted (based on M5) or ignored (if 'uncond')
wire uncond;                            // unconditional instruction, used to set cond=true

LUT6 #(.INIT(64'haaaaccccf0f0ff00)) lut_flag_set( .O(flag_set), .I0(Z), .I1(C), .I2(V), .I3(N), .I4(M[6]), .I5(M[7]) );
LUT5 #(.INIT(32'hfffeffff)) lut_uncond( .O(uncond), .I0(M[0]), .I1(M[1]), .I2(M[2]), .I3(M[3]), .I4(M[4]) );
LUT3 #(.INIT(32'hed)) lut_cond( .O(cond), .I0(flag_set), .I1(uncond), .I2(M[5]) );

endmodule
