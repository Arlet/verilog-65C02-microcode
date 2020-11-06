module microcode(
    input clk,
    input enable,
    input [8:0] addr,
    output [31:0] data );

wire [31:0] DO;
wire [3:0] DOP;

assign data = DO[31:0];

RAMB16BWER #(.DATA_WIDTH_A(36)) rom(
    .CLKA(clk),
    .DIA(32'b0),
    .DIPA(4'b0),
    .ENA(enable),
    .RSTA(1'b0),
    .WEA(1'b0),
    .ADDRA(addr),
    .DOA(DO),
    .DOPA(DOP) );

`include "microcode_init.v"

endmodule
