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
    input [4:0] op,         // operation
    input ld_ahl,           // indicates whether AHL should be loaded
    input ld_pc,            // indicates whether PCL should be loaded
    input inc_pc,           // indicates whether PCL should be incremented
    output pcl_co,          // Carry out from PCL
    output [7:0] PCL,       // Program Counter low
    output [7:0] AHL,       // Address Hold low
    output [7:0] ADL        // unregistered version of output
);

wire [7:0] ABL;
wire [7:0] base;

/*
 * AHL register. The AHL (Address Hold Low register) is a temporary
 * storage for DB input, most notably for use in 16 bit address
 * fetches, such as in the absolute addressing modes.
 *
 * Sometimes the DB has to be held over multiple cycles, such as
 * for JSR which fetches first operand byte before pushing old
 * PC to the stack, and then fetches 2nd operand byte.
 */

reg8 ahl( 
    .clk(clk),
    .EN(ld_ahl),
    .RST(0),
    .D(DB),
    .Q(AHL) );

/*
 * ABL logic has 2 stages. First stage selects a base register, 
 * 2nd stage adds an offset.
 *
 * There are a total of 6 useful combinations. 
 *
 * operation  | op[1:0] | application
 * ===========|=========|================================
 * PCL + 00   |   00    | PC restore
 * REG + 00   |   01    | stack access or vector pull 
 * ABL + DB   |   10    | take branch 
 * ABL + 00   |   01    | stay at current or move to next
 * REG + DB   |   10    | zeropage + index
 * REG + AHL  |   11    | abs + index
 * ======================================================
 * 
 */

/*   
 * First stage. Select base register. We use this
 * particular 3 bit encoding to match with the raw
 * output from the microcode ROM.
 *
 *  op   | base
 * ======|====
 * 000-- | PCL
 * 001-- | REG
 * 010-- | ABL
 * 011-- | REG
 * 100-- | ABL
 * 101-- | REG
 * 110-- | ABL
 * 111-- | REG
 */ 

genvar i;
generate for (i = 0; i < 8; i = i + 1 )
LUT6 #(.INIT(64'hccf0ccf0ccf0ccaa)) adl_base_mux(
    .O(base[i]), 
    .I0(PCL[i]), 
    .I1(REG[i]), 
    .I2(ABL[i]), 
    .I3(op[2]), 
    .I4(op[3]), 
    .I5(op[4]) );
endgenerate

/*   
 * Second stage. Add offset.
 *
 *  op  | function
 * =====|========= 
 * --00 | base + 00  + CI
 * --01 | base + 00  + CI
 * --10 | base + DB  + CI
 * --11 | base + AHL + CI
 */

add8_3 #(.INIT(64'h3c5af0f0c0a00000)) abl_add( 
    .CI(CI),
    .CO(CO),
    .I0(DB),
    .I1(AHL),
    .I2(base),
    .op({1'b1,op[1:0]}),
    .O(ADL) );

/* 
 * ABL register
 *
 * ABL <= ADL
 */ 
reg8 abl( 
    .clk(clk),
    .EN(1),
    .RST(0),
    .D(ADL),
    .Q(ABL) );

/*
 * update PCL (program counter low)
 * 
 * if( ld_pc )
 *     PCL <= ABL + inc_pc
 */

wire [7:0] PCL1;

add8_3 #(.INIT(64'haaaaaaaa00000000)) pcl_inc(
    .CI(inc_pc),
    .CO(pcl_co),
    .I0(ABL),
    .I1(0),
    .I2(0),
    .op(3'b100),
    .O(PCL1) );

/* 
 * PCL register
 */
reg8 pcl( 
    .clk(clk),
    .EN(ld_pc),
    .RST(0),
    .D(PCL1),
    .Q(PCL) );

endmodule
