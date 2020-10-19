/*
 * abh -- calculates next value of ABH (Address Bus High)
 *
 * (C) Arlet Ottens <arlet@c-scape.nl> 
 */
module abh( 
    input clk,
    input ff,               // reset to FF
    input CI,               // carry input from ABL module
    output reg [7:0] ABH,   // current ABH
    input [7:0] PCH,        // Program Counter high
    input [7:0] DBL,        // Data Bus
    input [2:0] op          // operation
);

initial
    ABH = 8'h04;            // for testing only

reg [7:0] ADH; 

/*   
 * op  |  function
 * ==================== 
 * 0?? |  00  + 00 + CI
 * 100 |  ABH + 00 + CI
 * 101 |  ABH + FF + CI
 * 110 |  PCH + 00 + CI 
 * 111 |  DBL + 00 + CI
 */ 

always @(*)
    casez( op )
        3'b100: ADH = ABH   + 8'h00 + CI;
        3'b101: ADH = ABH   + 8'hff + CI;
        3'b110: ADH = PCH   + 8'h00 + CI;
        3'b111: ADH = DBL   + 8'h00 + CI;
        3'b0??: ADH = 8'h00 + 8'h00 + CI;
    endcase

/*
 * register the new value
 *
 * The 'ff' input exploits the synchronous reset
 * feature to reduce ADH muxing above.
 */

always @(posedge clk)
    if( ff )
        ABH <= 8'hff;
    else
        ABH <= ADH;

endmodule
