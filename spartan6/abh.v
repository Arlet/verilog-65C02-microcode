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
    output [7:0] PCH,       // Program Counter high
    output [7:0] ADH        // unregistered version of ABH
);

wire [7:0] ABH;
wire [7:0] ADD0;
wire [7:0] ADD1;
wire [7:0] PCH1;

/*   
 * op  |  function
 * ==================== 
 * 0?? |  00  + 00 + CI
 * 100 |  ABH + 00 + CI
 * 101 |  ABH + FF + CI
 * 110 |  PCH + 00 + CI 
 * 111 |  DB  + 00 + CI
 */ 

add8_3 #(.INIT(64'hccf055aa0000aa00)) adh_add0(
    .I0(ABH),
    .I1(DB),
    .I2(PCH),
    .op(op[1:0]),
    .CI(1'b0),
    .O(ADD0) );

add8_3 #(.INIT(64'hccf055aa0000aa00)) adh_add1(
    .I0(ABH),
    .I1(DB),
    .I2(PCH),
    .op(op[1:0]),
    .CI(1'b1),
    .O(ADD1) );

/* bit 0 is different */
LUT5 #(.INIT(32'hffe4ff00)) abh_mux0( 
    .O(ADH[0]), 
    .I0(CI), 
    .I1(ADD0[0]), 
    .I2(ADD1[0]), 
    .I3(op[2]), 
    .I4(op[3]) );

/* other bits are all the same */
genvar i;
generate for (i = 1; i < 8; i = i + 1 )
begin: abh_mux1
LUT5 #(.INIT(32'hffe40000)) abh_mux1( 
    .O(ADH[i]), 
    .I0(CI), 
    .I1(ADD0[i]), 
    .I2(ADD1[i]), 
    .I3(op[2]), 
    .I4(op[3]) );
end
endgenerate

    /*
    case( op[3:2] )
        2'b00:      ADH = 8'h00;
        2'b01:      ADH = 8'h01;
        2'b10:      ADH = CI ? ADD1 : ADD0; 
        2'b11:      ADH = 8'hff;
    endcase
*/

/* 
 * ABH register
 *
 * ABH <= ADH
 */ 
reg8 abh( 
    .clk(clk),
    .EN(1'b1),
    .RST(1'b0),
    .D(ADH),
    .Q(ABH) );

/*
 * update PCH (program counter high)
 * 
 * if( ld_pc )
 *     PCH <= ABH + inc_pc
 */

wire [7:0] PCH1;

inc8 pch_inc(
    .CI(inc_pc),
    .I(ABH),
    .O(PCH1) );

/* 
 * PCL register
 */
reg8 pch( 
    .clk(clk),
    .EN(ld_pc),
    .RST(1'b0),
    .D(PCH1),
    .Q(PCH) );

endmodule
