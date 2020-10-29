/*
 * simple dual ported register file
 *
 * (C) Arlet Ottens <arlet@c-scape.nl>
 */
module regfile(
    input clk,
    input [6:0] op,
    input [7:0] DI,
    output [7:0] DO );

reg [7:0] regs[15:0];                   // register file

/*
 *   # |init| Register
 *  ===|====|==========
 *   0 | 02 | X 
 *   1 | 03 | Y
 *   2 | 41 | A
 *   3 | FF | S
 *   4 | FE | not used
 *   5 | 01 | INC
 *   6 | FF | DEC
 *   7 | 00 | zero
 *   8 | FA | NMI
 *   9 | FC | RST 
 *   A | FE | BRK 
 */

/*
 * init conversion to 4 banks of 2 bits
 *
 *                  +--- each column is 4x2 bits for each register
 *                  v 
 * addr:  A9876543210
 * ---------------------
 * 1:0    20203123132   10_0010_0011_0110_1101_1110 
 * 3:2    33203033100   11_1110_0011_0011_1101_0000 
 * 5:4    33303033000   11_1111_0011_0011_1100_0000
 * 7:6    33303033100   11_1111_0011_0011_1101_0000
 */

wire [4:0] reg_wr = {3'b000, op[5:4]};    // register file select
wire [4:0] reg_rd = {1'b0,   op[3:0]};    // register file select
wire we = op[6];

/*
 * lower nibble of register file
 *
 * The RAM32M primitive is implemented using 4 LUTs in a single slice
 * 
 * It has 4 address ports, which can all be used for reading. 
 * The write address is shared between all 4, and given in ADDRD.
 * Each port gives access to 2 bits. We can't read from port D, 
 * which only leaves 6 possible read bits.
 *
 * Since we need 8 bits total, we use 2 memories, and only use
 * 4 bits from each.
 */
RAM32M #(.INIT_A(64'h2236DE), .INIT_B(64'h3E33DC)) ram_l(
    .ADDRA(reg_rd),
    .ADDRB(reg_rd),
    .ADDRC(5'b0),
    .ADDRD(reg_wr),
    .DIA(DI[1:0]),
    .DIB(DI[3:2]),
    .DIC(2'b0),
    .DID(2'b0),
    .WCLK(clk),
    .WE(we),
    .DOA(DO[1:0]),
    .DOB(DO[3:2]) );

/*
 * higher nibble of register file
 */
RAM32M #(.INIT_A(64'h3F33C0), .INIT_B(64'h3F33D0)) ram_h(
    .ADDRA(reg_rd),
    .ADDRB(reg_rd),
    .ADDRC(5'b0),
    .ADDRD(reg_wr),
    .DIA(DI[5:4]),
    .DIB(DI[7:6]),
    .DIC(2'b0),
    .DID(2'b0),
    .WCLK(clk),
    .WE(we),
    .DOA(DO[5:4]),
    .DOB(DO[7:6]) );

endmodule