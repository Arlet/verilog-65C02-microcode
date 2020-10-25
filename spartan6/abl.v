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
    input [2:0] op,         // operation
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
 * second stage adds either REG/ABL, zero, or replaces input
 * by REG. The carry input is always added as well.
 *
 * There are a total of 6 useful combinations. First stage examines
 * all 3 op[] bits, 2nd stage only examines lower two.
 *
 * operation  | op[2] | op[1:0] | application
 * ===========|=======|=========|==================================
 * PCL + 00   |   x   |   00    | PC restore
 *    REG     |   x   |   01    | stack access or vector pull 
 * DB  + ABL  |   0   |   10    | take branch 
 * 00  + ABL  |   1   |   10    | stay at current or move to next
 * DB  + REG  |   0   |   11    | zeropage + index
 * AHL + REG  |   1   |   11    | abs + index
 * ================================================================
 * 
 */

reg [7:0] base;

/*   
 * First stage. Select base register.
 */ 
always @(*)
    casez( op[2:0] )
        3'b?00: base = PCL;
        3'b?01: base = 8'hxx;
        3'b110: base = 00;
        3'b01?: base = DB;
        3'b111: base = AHL;
    endcase

/*   
 * Second stage. Add offset.
 *
 *  op  | function
 * =====|========= 
 * --00 | base + 00  + CI
 * --01 |  00  + REG + CI
 * --10 | base + ABL + CI
 * --11 | base + REG + CI
 */

add8_3 #(.INIT(64'h3c5accf0c0a00000)) abl_add(
    .CI(CI),
    .CO(CO),
    .I0(ABL),
    .I1(REG),
    .I2(base),
    .op({1'b1,op[1:0]}),
    .O(ADL) );

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
