/*
 * abh -- calculates next value of ABH (Address Bus High)
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 */
module abh( 
    input clk,
    input CI,               // carry input from ABL module
    input [7:0] DB,         // Data Bus
    input [3:0] op,         // operation
    input ld_pc,            // load PC 
    input inc_pc,           // increment PC
    output reg [7:0] PCH,   // Program Counter high
    output reg [7:0] ADH    // unregistered version of ABH
);

reg [7:0] ABH;
reg [7:0] ADH;
reg [7:0] ADH0;             // assume CI = 0
reg [7:0] ADH1;             // assume CI = 1

/*   
 * op[1:0] |  function
 * ========|=========== 
 *    00   |  ABH + 00 + CI
 *    01   |  ABH + FF + CI
 *    10   |  PCH + 00 + CI 
 *    11   |  DB  + 00 + CI
 */ 

/*
 * ADH0 assumes CI is 0.
 */
always @(*)
    case( op[1:0] )
        2'b00: ADH0 = ABH + 8'h00;
        2'b01: ADH0 = ABH + 8'hff;
        2'b10: ADH0 = PCH + 8'h00;
        2'b11: ADH0 = DB  + 8'h00;
    endcase

/*
 * ADH1 assumes CI is 1.
 */
always @(*)
    case( op[1:0] )
        2'b00: ADH1 = ABH + 8'h01;
        2'b01: ADH1 = ABH + 8'h00;
        2'b10: ADH1 = PCH + 8'h01;
        2'b11: ADH1 = DB  + 8'h01;
    endcase

/*
 * op[3:2] |  function
 * ========|=========== 
 *    00   |  PAGE 00
 *    01   |  PAGE 01
 *    10   |  ADH0/ADH1  
 *    11   |  PAGE FF
 */
always @(*)
    case( op[3:2] )
        2'b00:  ADH = 8'h00;
        2'b01:  ADH = 8'h01;
        2'b10:  ADH = CI ? ADH1 : ADH0;
        2'b11:  ADH = 8'hff;
    endcase

/*
 * register the new value
 */
always @(posedge clk)
    ABH <= ADH;

/*
 * update Program Counter High
 */
always @(posedge clk)
    if( ld_pc )
        PCH <= ABH + inc_pc;

endmodule
