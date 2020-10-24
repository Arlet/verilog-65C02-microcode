/*
 * abh -- calculates next value of ABH (Address Bus High)
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 */
module abh( 
    input clk,
    input ff,               // reset to FF
    input CI,               // carry input from ABL module
    input [7:0] DB,         // Data Bus
    input [2:0] op,         // operation
    input ld_pc,            // load PC 
    input inc_pc,           // increment PC
    output reg [7:0] PCH,   // Program Counter high
    output reg [7:0] ADH    // unregistered version of ABH
);

reg [7:0] ABH;

/*   
 * op  |  function
 * ==================== 
 * 0?? |  00  + 00 + CI
 * 100 |  ABH + 00 + CI
 * 101 |  ABH + FF + CI
 * 110 |  PCH + 00 + CI 
 * 111 |  DB  + 00 + CI
 */ 
always @(*)
    casez( {ff, op} )
        4'b0100: ADH = ABH   + 8'h00 + CI;
        4'b0101: ADH = ABH   + 8'hff + CI;
        4'b0110: ADH = PCH   + 8'h00 + CI;
        4'b0111: ADH = DB    + 8'h00 + CI;
        4'b00??: ADH = 8'h00 + 8'h00 + CI;
        4'b1???: ADH = 8'hff;
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
