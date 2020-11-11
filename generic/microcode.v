module microcode(
    input clk,
    input [8:0] addr,
    output reg [30:0] data );

reg [31:0] rom[0:511];

initial $readmemb( "microcode.hex", rom, 0 );

always @(posedge clk)
    data <= rom[addr];

endmodule
