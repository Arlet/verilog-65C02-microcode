/*
 * abl -- calculates next value of ABL (Address Bus Low)
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 *
 */

module abl( 
    input clk,
    input CI,               // carry input
    output CO,              // carry output
    output reg [7:0] ABL,   // current ABL
    input [7:0] PCL,        // Program Counter low
    input [7:0] DBL,        // Data Bus Low
    input [7:0] AHL,        // Address Hold low
    input [7:0] REG,        // output from register file
    input [3:0] op          // operation
);

initial
    ABL = 8'h00;

/*
 * ABL logic has 2 stages.
 *
 * First stage selects base register from 00,PCL,AHL or DBL
 * second stage adds either REG/ABL.
 */

reg [7:0] base;

/*   
 * First stage:
 *
 *  op  | function
 * =============== 
 * 00-- | 00 
 * 01-- | PCL 
 * 10-- | AHL
 * 11-- | DBL
 *
 */ 

always @(*)
    case( op[3:2] )
        2'b00: base = 00;
        2'b01: base = PCL;
        2'b10: base = AHL;
        2'b11: base = DBL;
    endcase

/*   
 * Second stage:
 *
 *  op  | function
 * =============== 
 * --00 | base + 00  + CI
 * --10 | base + ABL + CI
 * --11 | base + REG + CI
 */

reg [8:0] ADL;

always @(*)
    case( op[1:0] )
        2'b00: ADL = base + 00  + CI;
        2'b10: ADL = base + ABL + CI;
        2'b11: ADL = base + REG + CI;
    endcase

always @(posedge clk)
	ABL <= ADL[7:0];

assign CO = ADL[8]; 

endmodule
