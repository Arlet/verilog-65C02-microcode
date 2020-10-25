/*
 * abl -- outputs ABL (Address Bus Low)
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 *
 */

module abl( 
    input clk,
    input CI,               // carry input
    output CO,              // carry output
    input [7:0] DB,         // Data Bus 
    input [7:0] REG,        // output from register file
    input [3:0] op,         // operation
    input ld_ahl,           // indicates whether AHL should be loaded
    input ld_pc,            // indicates whether PCL should be loaded
    input inc_pc,           // indicates whether PCL should be incremented
    output pcl_co,          // Carry out from PCL
    output reg [7:0] PCL,   // Program Counter low
    output reg [7:0] AHL,   // Address Hold low
    output [7:0] ADL    // unregistered version of output
);

reg [7:0] ABL;

/*
 * AHL update. The AHL (Address Hold register) is a temporary
 * storage for DB input, most notably for use in 16 bit address
 * fetches, such as in the absolute addressing modes.
 *
 * Sometimes the DB has to be held over multiple cycles, such as
 * for JSR which fetches first operand byte before pushing old
 * PC to the stack, and then fetches 2nd operand byte.
 */
always @(posedge clk)
    if( ld_ahl )
        AHL <= DB;

/*
 * ABL logic has 2 stages.
 *
 * First stage selects base register from 00, DB, AHL or PCL 
 * second stage adds either REG/ABL, or nothing. The carry
 * input is always added as well.
 */

reg [7:0] base;

/*   
 * First stage:
 *
 *  op  | function
 * =============== 
 * 00-- | 00 
 * 01-- | DB
 * 10-- | AHL
 * 11-- | PCL
 *
 */ 

always @(*)
    case( op[3:2] )
        2'b00: base = 00;
        2'b01: base = DB;
        2'b10: base = AHL;
        2'b11: base = PCL;
    endcase

/*   
 * Second stage:
 *
 *  op  | function
 * =============== 
 * --00 | base + 00  + CI
 * --01 | base + 00  + CI
 * --10 | base + ABL + CI
 * --11 | base + REG + CI
 *
 */

wire [7:0] P;       // carry propagate
wire [7:0] G;       // carry generate

genvar i;
generate for (i = 0; i < 8; i = i + 1 )
begin : adl_loop
LUT6_2 #(.INIT(64'h665aaaaa88a00000)) adl_lut( 
	.O6(P[i]), 
	.O5(G[i]), 
	.I0(base[i]), 
	.I1(REG[i]), 
	.I2(ABL[i]), 
	.I3(op[0]), 
	.I4(op[1]), 
	.I5(1'b1) );
end
endgenerate

wire [3:0] COL;  // carry out of lower nibble
wire [3:0] COH;  // carry out of higher nibble

CARRY4 carry_l ( .CO(COL), .O(ADL[3:0]), .CI(CI),     .CYINIT(1'b0), .DI(G[3:0]), .S(P[3:0]) );
CARRY4 carry_h ( .CO(COH), .O(ADL[7:4]), .CI(COL[3]), .CYINIT(1'b0), .DI(G[7:4]), .S(P[7:4]) );

assign CO = COH[3];

always @(posedge clk)
	ABL <= ADL;

/*
 * update PCL (program counter low)
 */
wire [8:0] PCL1 = ABL + inc_pc;

assign pcl_co = PCL1[8];

always @(posedge clk)
    if( ld_pc )
        PCL <= PCL1;

endmodule
