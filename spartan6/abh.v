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

wire [7:0] ADD0;
wire [7:0] ADD1;

add8_3 #(.INIT(64'hccf055aa0000aa00)) adh_add0(
    .I0(ABH),
    .I1(DB),
    .I2(PCH),
    .op(op),
    .CI(0),
    .O(ADD0) );

add8_3 #(.INIT(64'hccf055aa0000aa00)) adh_add1(
    .I0(ABH),
    .I1(DB),
    .I2(PCH),
    .op(op),
    .CI(1),
    .O(ADD1) );

always @(*)
    if( ff )        ADH = 8'hff;
    else if( CI )   ADH = ADD1;
    else            ADH = ADD0;

//assign ADH = ADD | (ff ? 8'hFF : 8'h00);

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
