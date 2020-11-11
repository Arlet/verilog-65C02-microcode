/*
 * generate control signals for 65C02 core.
 *
 * This module is organized around a 512x36 bit memory. Half of the
 * memory is used for instruction decoding. The opcode is used as the
 * address (with top bit set to 0). The output is a control word that
 * controls both address and ALU logic, as well as the register file
 * addressing, and flag updates. The sequencer has no conditional
 * branches and no internal register file. It simply follows a fixed
 * sequence of micro-instructions. Each word contains the address of the next.
 *
 * The other half of the memory is used as a sequencer for multi-cycle
 * instructions.
 *
 * Most instructions that operate on memory are divided into two
 * phases. The first phase determines the effective memory address, the
 * second (and final) phase performs the operation.
 *
 * In order to save space, the ROM has a separate area for the 2nd
 * phase, called the 'finishing code'. The first cycle of the control
 * word optionally contains the address of the 'finisher', stored in
 * 5 bit register 'finish'. After the memory has been addressed, the
 * controller jumps to the finish code to do the operations. This allows
 * for a compact representation.
 *
 * So, for example, the code for LDA ZP points to a finisher that loads ALU
 * into A register. The code for LDX ZP points to a finisher that loads X
 * register instead. Both instructions then follow the same sequence to read
 * zeropage, and then the respective finisher is called.
 *
 * In the last cycle of an instruction, we no longer need the next location,
 * so the 8 address bits are used to select how the processor status flags
 * are updated.
 *
 * (C) Arlet Ottens <arlet@c-scape.nl>
 */

module ctl(
    input clk,
    input irq,
    input nmi,
    input rdy,
    input reset,
    output sync,
    input cond,
    input [7:0] DB,
    output reg WE,
    output [9:0] flag_op,
    output [6:0] alu_op,
    output [6:0] reg_op,
    output [1:0] do_op,
    output ld_m,
    input I,
    input D,
    output B,
    output reg [11:0] ab_op );

wire [2:0] adder;
wire [1:0] shift;
wire [1:0] ci;
wire [3:0] src;
wire [2:0] dst;

assign ld_m = control[31] & rdy;
assign flag_op = {control[30:29], control[7:0]};
assign alu_op = { shift, adder, ci };
assign reg_op = control[21:15];

reg [8:0] pc;
wire [31:0] control;
reg [4:0] finish;   // finishing code

microcode rom(
    .clk(clk),
    .enable(1'b1),
    .reset(reset),
    .addr(pc),
    .data(control) );

/*
 * operation for DO (data out)
 */
assign do_op = control[30:29];

/*
 * sync indicates when new instruction is decoded
 */
assign sync = (control[23:22] == 2'b00);

/*
 * The microcontrol 'program counter'.
 *
 * The bits in control[23:22] tell what to do:
 *
 * when 00 -> decode next instruction, form address in bottom 256 words.
 *            or jump to IRQ/NMI handler if necessary.
 * when 01 -> jump to next microcode instruction in area 9'h100-9'h17F
 * when 10 -> jump to finishing code in area 9'h140-9'h15F.
 * when 11 -> jump to next, but also save pointer to finishing code
 */

wire take_irq = irq & ~I;

/*
 * First, form a 2 bit select signal from the interrupt signals
 * and control bits.
 * 
 * sel_pc 
 * ------
 * 00 fetch
 * 01 next
 * 10 finish
 * 11 IRQ/NMI
 */
reg [1:0] sel_pc;

always @(*)
    casez( {nmi, take_irq, control[23:22]} )
        4'b1?00:    sel_pc = 2'b11;                 // take NMI
        4'b0100:    sel_pc = 2'b11;                 // take IRQ
        4'b00?1:    sel_pc = 2'b01;                 // next
        4'b0000:    sel_pc = 2'b00;                 // fetch
        4'b0010:    sel_pc = 2'b10;                 // finish 
    endcase

/* 
 * 9 bit address in microcode ROM (the 'pc')
 *
 * sel   8   7   6   5   4   3   2   1   0
 *     +---+---+---+---+---+---+---+---+---+
 * 00: | 0 |           opcode (DB)         |   opcode lookup
 *     +---+---+---+---+---+---+---+---+---+
 * 01: | 1 | D |        jmp next           |   next instruction 
 *     +---+---+---+---+---+---+---+---+---+
 * 10: | 1 | D | 1   0 |      finish       |   finish handler 
 *     +---+---+---+---+---+---+---+---+---+
 * 11: | 1 |N/I| 1   1   0   0   0   0   0 |   IRQ/NMI handler @160
 *     +---+---+---+---+---+---+---+---+---+
 */

always @(*)
    case( sel_pc )
        2'b00:      pc = {1'b0, DB};                // look up next instruction at @000-@0FF
        2'b01:      pc = {1'b1, D, control[6:0]};   // microcode at @100/@180
        2'b10:      pc = {1'b1, D, 2'b10, finish }; // finish code at @140/@1C0
        2'b11:      pc = {1'b1, nmi, 7'b1100000 };  // take NMI/IRQ at @1E0/160
    endcase

/*
 * bit 28 contains WE signal for next cycle
 */
always @(posedge clk)
    WE <= control[28];

/*
 * if bit 23 is set, the ALU is not needed in this cycle
 * so the same bits are used to store location of finisher code
 */
always @(posedge clk)
    if( control[23] )
        finish <= control[14:10];

/*
 * control bits for ALU
 */
assign shift = control[14:13];
assign adder = control[12:10];
assign ci    = control[9:8];

/*
 * take B from CI control bits. We only care about the 'B'
 * bit when pushing the status bits to the stack. At that
 * time we don't use the ALU carry bits.
 */
assign B = control[8];

/*
 * The ABL/ABH modules need 12 bits of control signals, but only in a limited
 * number of total options.
 *
 * In order to compress those in the control word, the code below expands
 * the 4 control bits into 12, optionally taking into account the output
 * of the conditional branches, and the branch direction (DB[7])
 */

wire abl_ci = control[26];
wire [1:0] abl_sel = control[25:24];
wire back = cond & DB[7];     // doing backwards branch 

always @(*)
    case( control[27:24] )    //             IPH_ABH____________ABL OP
        4'b0000:                ab_op = { 7'b001_0110, abl_sel, 2'b11, abl_ci };  // AB + 0
        4'b0001:                ab_op = { 7'b000_1010, abl_sel, 2'b10, abl_ci };  // PC
        4'b0010:                ab_op = { 7'b111_1110, abl_sel, 2'b01, abl_ci };  // {DB, AHL+REG}, store PC
        4'b0011:                ab_op = { 7'b111_0000, abl_sel, 2'b01, abl_ci };  // {00, DB+REG}
        4'b0100:                ab_op = { 7'b001_0110, abl_sel, 2'b11, abl_ci };  // AB + 1
        4'b0101:                ab_op = { 7'b011_0001, abl_sel, 2'b00, abl_ci };  // {01, SP+1}
        4'b0111: if( back )     ab_op = { 7'b011_0111, abl_sel, 2'b11, abl_ci };  // {AB-1, AB} + DB + 1
                 else           ab_op = { 7'b011_0110, abl_sel, 2'b11, abl_ci };  // AB + 1
        4'b1000:                ab_op = { 7'b000_0001, abl_sel, 2'b00, abl_ci };  // {01, SP}, keep PC
        4'b1001:                ab_op = { 7'b111_0001, abl_sel, 2'b00, abl_ci };  // {01, SP}, store PC+1
        4'b1010:                ab_op = { 7'b001_1110, abl_sel, 2'b01, abl_ci };  // {DB, AHL+REG}, keep PC
        4'b1011:                ab_op = { 7'b010_0001, abl_sel, 2'b00, abl_ci };  // {01, SP}
        4'b1100:                ab_op = { 7'b001_0110, abl_sel, 2'b11, abl_ci };  // AB+1, keep PC
        4'b1111:                ab_op = { 7'b000_0011, abl_sel, 2'b00, abl_ci };  // {FF, REG} + 1
        default:                ab_op = { 7'bxxx_xxxx, abl_sel, 2'bxx, abl_ci };
    endcase

endmodule
