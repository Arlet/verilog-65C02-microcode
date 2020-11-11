module microcode(
    input clk,
    input enable,
    input reset,
    input [8:0] addr,
    output reg [31:0] data );

localparam RESET = 32'b000_00000_01_000_0000_00000_00_01110000;

reg [31:0] rom[0:511];

initial $readmemb( "microcode.hex", rom, 0 );
initial data = RESET;

always @(posedge clk)
    if( enable )
        if( reset )
            data <= RESET;
        else
            data <= rom[addr];

endmodule
