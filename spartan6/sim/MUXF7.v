/*
 * implementation of Spartan-6 MUXF7 for simulation
 */
module MUXF7(
    input I0,
    input I1,
    input S,
    output reg O );

	always @(*) 
        O = S ? I1 : I0;
endmodule

