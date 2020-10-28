/*
 * abl -- outputs ABL (Address Bus Low)
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 *
 */

module abl( 
    input clk,
    input CI,               // carry input
    input cond,             // condition code input
    output reg CO,          // carry output
    input [7:0] DB,         // Data Bus 
    input [7:0] REG,        // output from register file
    input [4:0] op,         // operation
    input ld_ahl,           // indicates whether AHL should be loaded
    input ld_pc,            // indicates whether PCL should be loaded
    input inc_pc,           // indicates whether PCL should be incremented
    output pcl_co,          // Carry out from PCL
    output reg [7:0] PCL,   // Program Counter low
    output reg [7:0] AHL,   // Address Hold low
    output reg [7:0] ADL    // unregistered version of output
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
 * ABL logic has 2 stages. First stage selects a base register, 
 * 2nd stage adds an offset.
 *
 * There are a total of 6 useful combinations. 
 *
 * operation  |  application
 * ===========|=================================
 * PCL + 00   |  PC restore
 * REG + 00   |  stack access or vector pull 
 * ABL + DB   |  take branch 
 * ABL + 00   |  stay at current or move to next
 * REG + DB   |  zeropage + index
 * REG + AHL  |  abs + index
 * =============================================
 * 
 */
reg [7:0] base;

/*   
 * First stage. Select base register.
 */ 
always @(*)
    casez( {cond, op[4:2]} )
        4'b?00?: base = 8'h00;
        4'b?010: base = PCL;
        4'b?011: base = AHL;
        4'b?10?: base = DB;
        4'b0110: base = 8'h00;
        4'b0111: base = DB;
        4'b1110: base = DB;
        4'b1111: base = 8'h00;
    endcase

/*   
 * Second stage. Add offset, or replace
 * by REG.
 *
 *  op  | function
 * =====|========= 
 * --00 |   REG + CI
 * --01 | + REG + CI
 * --10 | + 00  + CI
 * --11 | + ABL + CI
 */
always @(*)
    case( op[1:0] )
        2'b00: {CO, ADL} = REG + CI;
        2'b01: {CO, ADL} = base + REG + CI;
        2'b10: {CO, ADL} = base + CI;
        2'b11: {CO, ADL} = base + ABL + CI;
    endcase

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
