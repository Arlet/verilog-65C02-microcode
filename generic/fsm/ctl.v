/*
 * generate control signals for 65C02 core.
 *
 * (C) Arlet Ottens <arlet@c-scape.nl>
 */

module ctl(
    input clk,
    input irq,
    input rdy,
    input nmi,
    input reset,
    output sync,
    input cond,
    input [7:0] DB,
    output reg WE,
    output [9:0] flag_op,
    output reg [8:0] alu_op,
    output reg [6:0] reg_op,
    output reg [1:0] do_op,
    output ld_m,
    input I,
    input D,
    output B,
    output reg [11:0] ab_op );

wire [31:0] control;

/*
 * The NMI signal is edge sensitive. Detect edge,
 * register it in 'take_nmi', and clear it at 
 * the next sync pulse, when the NMI is actually
 * taken.
 */
reg nmi1;
reg take_nmi;

always @(posedge clk)
    nmi1 <= nmi;

always @(posedge clk)
    if( nmi & ~nmi1 )
        take_nmi <= 1;
    else if( sync & rdy )
        take_nmi <= 0;

/*
 * take irq when 'irq' is present and not disabled.
 * (priority of irq/nmi will be decided in 'sel_pc' mux)
 */
wire take_irq = irq & ~I;

//assign B = control[8];

reg [3:0] mode;

/*
 * The 4 'mode' bits control the AB datapath. The AB datapath (ABL+ABH) 
 * require a total of 12 control signals, but there are only 15 unique
 * and useful combinations, listed in the table below.
 *
 * The "PC" (consisting of PCH and PCL) is not really the "Program Counter"
 * but simply a holding register for when AB needs to access data. It can
 * either keep the old value, or load it with AB, optionally incremented.
 *
 * The "AHL" is the hold register that stores DB for the next cycle, to be
 * used whenever a 16 bit address appears on the bus. 
 *
 * In case of a branch (mode 0111), the ABL module chooses between DB/00 
 * offset based on its own condition code inputs. The choice for FF/00 
 * for ABH is done here.
 *
 * mode |   PC   | AHL  | AB
 * -----+--------+------+------
 * 0000 |  keep  |  DB  | keep
 * 0001 |  keep  | keep | PC
 * 0010 | AB + 1 |  DB  | {DB, AHL + XYZ} 
 * 0011 | AB + 1 |  DB  | {00, DB  + XYZ} 
 * 0100 |   AB   |  DB  | AB + 1 
 * 0101 |   AB   |  DB  | {01, SP + 1}
 * 0111 |   AB   |  DB  | AB + { FF, DB } + 1   (if backward branch taken) 
 * 0111 |   AB   |  DB  | AB + { 00, DB } + 1   (if forward branch taken)
 * 0111 |   AB   |  DB  | AB + { 00, 00 } + 1   (if branch not taken)
 * 1000 |  keep  | keep | {01, SP} 
 * 1001 | AB + 1 |  DB  | {01, SP}
 * 1010 |  keep  |  DB  | {DB, AHL + XYZ}
 * 1011 |   AB   | keep | {01, SP}
 * 1100 |  keep  |  DB  | AB + 1
 * 1110 |  keep  |  DB  | {DB, AHL + XYZ} + 1
 * 1111 |  keep  | keep | { FF, VECTOR } + 1
 *  |||
 *  |++----> mode bits [1:0] go directly into ABL mux selection
 *  |
 *  +------> mode bit [2] goes directly into ABL carry input
 */

wire abl_ci = mode[2];
wire [1:0] abl_sel = mode[1:0];
wire back = cond & DB[7];     // doing backwards branch 

always @(*)
    case( mode )              //             IPH_ABH____________ABL OP
        4'b0000:                ab_op = { 7'b001_0110, abl_sel, 2'b11, abl_ci };  // AB + 0
        4'b0001:                ab_op = { 7'b000_1010, abl_sel, 2'b10, abl_ci };  // PC
        4'b0010:                ab_op = { 7'b111_1110, abl_sel, 2'b01, abl_ci };  // {DB, AHL+REG}, store PC
        4'b0011:                ab_op = { 7'b111_0000, abl_sel, 2'b01, abl_ci };  // {00, DB+REG}
        4'b0100:                ab_op = { 7'b011_0110, abl_sel, 2'b11, abl_ci };  // AB + 1, store PC
        4'b0101:                ab_op = { 7'b011_0001, abl_sel, 2'b00, abl_ci };  // {01, SP+1}
        4'b0111: if( back )     ab_op = { 7'b011_0111, abl_sel, 2'b11, abl_ci };  // {AB-1, AB} + DB + 1
                 else           ab_op = { 7'b011_0110, abl_sel, 2'b11, abl_ci };  // AB + 1
        4'b1000:                ab_op = { 7'b000_0001, abl_sel, 2'b00, abl_ci };  // {01, SP}, keep PC
        4'b1001:                ab_op = { 7'b111_0001, abl_sel, 2'b00, abl_ci };  // {01, SP}, store PC+1
        4'b1010:                ab_op = { 7'b001_1110, abl_sel, 2'b01, abl_ci };  // {DB, AHL+REG}, keep PC
        4'b1011:                ab_op = { 7'b010_0001, abl_sel, 2'b00, abl_ci };  // {01, SP}
        4'b1100:                ab_op = { 7'b001_0110, abl_sel, 2'b11, abl_ci };  // AB+1, keep PC
        4'b1110:                ab_op = { 7'b001_1110, abl_sel, 2'b01, abl_ci };  // {DB, AHL+REG} + 1, keep PC
        4'b1111:                ab_op = { 7'b000_0011, abl_sel, 2'b00, abl_ci };  // {FF, REG} + 1
        default:                ab_op = { 7'bxxx_xxxx, abl_sel, 2'bxx, abl_ci };  // avoid latches
    endcase

/*
 * control state machine
 */
parameter
    INIT  = 6'd0,
    SYNC  = 6'd1,
    BACK  = 6'd2,
    IMM0  = 6'd3,
    IND0  = 6'd4,
    IND1  = 6'd5,
    DATA  = 6'd6,
    ABS0  = 6'd7,
    ABS1  = 6'd8,
    ZERO  = 6'd9,
    IND2  = 6'd10,
    PULL  = 6'd11,
    RDWR  = 6'd12,
    RTS0  = 6'd13,
    RTS1  = 6'd14,
    RTS2  = 6'd15,
    PUSH  = 6'd16,
    JSR0  = 6'd17,
    JSR1  = 6'd18,
    JSR2  = 6'd19,
    BRK0  = 6'd20,
    BRK1  = 6'd21,
    BRK2  = 6'd22,
    BRK3  = 6'd23,
    RTI0  = 6'd24,
    RTI1  = 6'd25,
    RTI2  = 6'd26,
    RTI3  = 6'd27,
    COND  = 6'd28
    ;

reg [5:0] state = INIT;

assign sync = (state == SYNC);

/*
 * write enable 
 */
always @(posedge clk)
    case( state )
        BRK0:    WE <= 1;
        BRK1:    WE <= 1;
        BRK2:    WE <= 1;
        JSR0:    WE <= 1;
        JSR1:    WE <= 1;
        RTS0:    WE <= 0;
        RTS1:    WE <= 0;
        default: WE <= 0;
    endcase

/*
 * data output select
 * 
 * 00 ALU
 * 01 P
 * 10 PCL
 * 11 PCH
 */
always @(*)
    case( state )
        BRK1:   do_op = 2'b11;
        BRK2:   do_op = 2'b10;
        BRK3:   do_op = 2'b01;
        JSR1:   do_op = 2'b11;
        JSR2:   do_op = 2'b10;
     default:   do_op = 2'bxx;
    endcase

/*
 * register operation
 *
 *   6   5   4   3   2   1   0
 * +---+---+---+---+---+---+---+
 * | W |  dst  |      src      |
 * +---+---+---+---+---+---+---+
 */
always @(*)
    case( state )
        BRK0:           reg_op = 7'b1_11_0011; // S
        BRK1:           reg_op = 7'b1_11_0011; // S
        BRK2:           reg_op = 7'b1_11_0011; // S
        BRK3:           reg_op = 7'b0_00_1010; // BRK vector
        JSR0:           reg_op = 7'b1_11_0011; // S
        JSR1:           reg_op = 7'b1_11_0011; // S
        RTS0:           reg_op = 7'b1_11_0011; // S
        RTS1:           reg_op = 7'b1_11_0011; // S
        RTI0:           reg_op = 7'b1_11_0011; // S
        RTI1:           reg_op = 7'b1_11_0011; // S
        RTI2:           reg_op = 7'b1_11_0011; // S
        IND0: if( zpx ) reg_op = 7'b0_00_0000; // X
              else      reg_op = 7'b0_00_0111; // Z
        IND2: if( zpy ) reg_op = 7'b0_00_0001; // Y
              else      reg_op = 7'b0_00_0111; // Z
     default:           reg_op = 7'b0_00_0111; // Z
    endcase

/*
 * ALU operation
 *
 * shift           add
 * -----         --------
 *  10 left      000 OR 
 *  11 right     001 AND
 *               010 XOR
 * carry         011 ADD
 * -----         100 INC
 *  01 1         101 DEC
 *  10 ROT       110 SUB
 *  11 ADC       111 TRB
 *
 *   8   7   6   5   4   3   2   1   0
 * +---+---+---+---+---+---+---+---+---+
 * |ldm|bcd| shift |    add    | carry |
 * +---+---+---+---+---+---+---+---+---+
 */
always @(*)
    case( state )
        BRK0:    alu_op = 9'b00_00_101_00;  // - 1 
        BRK1:    alu_op = 9'b00_00_101_00;  // - 1 
        BRK2:    alu_op = 9'b00_00_101_00;  // - 1 
        JSR0:    alu_op = 9'b00_00_101_00;  // - 1 
        JSR1:    alu_op = 9'b00_00_101_00;  // - 1 
        RTS0:    alu_op = 9'b00_00_100_01;  // + 1 
        RTS1:    alu_op = 9'b00_00_100_01;  // + 1 
        RTI0:    alu_op = 9'b00_00_100_01;  // + 1
        RTI1:    alu_op = 9'b00_00_100_01;  // + 1
        RTI2:    alu_op = 9'b00_00_100_01;  // + 1
        default: alu_op = 9'bxx_xx_xxx_xx;   
    endcase

always @(*)
    case( state )
        BACK:   mode = 1;
        INIT:   mode = 0;
        SYNC:   mode = 4;
        ABS0:   mode = 4;
        ABS1:   mode = 2;
        IND0:   mode = 3;
        IND1:   mode = 12;
        IND2:   mode = 10;
        ZERO:   mode = 3;
        IMM0:   mode = 4;
        PULL:   mode = 5;
        PUSH:   mode = 11;
        RDWR:   mode = 0;
        RTS0:   mode = 5;
        RTS1:   mode = 5;
        RTS2:   mode = 14;
        RTI0:   mode = 5;
        RTI1:   mode = 5;
        RTI2:   mode = 5;
        RTI3:   mode = 2;
        JSR0:   mode = 9;
        JSR1:   mode = 8;
        JSR2:   mode = 1;
        BRK0:   mode = 9;
        BRK1:   mode = 8;
        BRK2:   mode = 8;
        BRK3:   mode = 15;
        COND:   mode = 7;
    endcase

/* 
 * loose state flops
 */
reg rmw, jmp, ind, zpx, zpy;

/*
 * read-modify-write bit. When set, it means
 * we hold the address for extra cycle
 */
always @(posedge clk)
    if( sync )
        case( DB )
            8'h06:  rmw <= 1;
        default:    rmw <= 0;
        endcase

/*
 * jmp bit, indicates that we're jumping to
 * absolute address instead of using it for
 * data
 */
always @(posedge clk)
    if( sync )
        case( DB )
            8'h00:  jmp <= 1;
            8'h20:  jmp <= 1;
            8'h40:  jmp <= 1;
            8'h4c:  jmp <= 1;
            8'h60:  jmp <= 1;
            8'h6c:  jmp <= 1;
            8'h7c:  jmp <= 1;
        default:    jmp <= 0;
        endcase

/*
 * indirect bit. Does 16 bit indirected
 * addresses. Needs to be cleared when 
 * used in ABS1 state, otherwise, it will
 * continue to loop indirections.
 */
always @(posedge clk)
    if( sync )
        case( DB )
            8'h6c:  ind <= 1;
            8'h7c:  ind <= 1;
        default:    ind <= 0;
        endcase
    else if( state == ABS1 )
        ind <= 0;

/*
 * zpy: use Y register as offset for (ZP),Y 
 */
always @(posedge clk)
    if( sync )
        case( DB )
            8'hB1:  zpy <= 1;               // LDA (ZP),Y
        default:    zpy <= 0;
        endcase
/*
 * zpx: use X register as offset for (ZP,X)
 */
always @(posedge clk)
    if( sync )
        case( DB )
            8'hA1:  zpx <= 1;               // LDA (ZP,X)
        default:    zpx <= 0;
        endcase

always @(posedge clk)
    case( state )
        INIT:   state <= SYNC;
        SYNC:   
            case( DB )
                8'h80:  state <= COND;      // BRA
                8'h00:  state <= BRK0;      // BRK
                8'h20:  state <= JSR0;      // JSR
                8'h40:  state <= RTI0;      // RTI
                8'h60:  state <= RTS0;      // RTS
                8'h4C:  state <= ABS0;      // JMP ABS
                8'h6C:  state <= ABS0;      // JMP (IND)
                8'hAD:  state <= ABS0;      // LDA ABS 
                8'h06:  state <= ZERO;      // ASL ZP
                8'hA5:  state <= ZERO;      // LDA ZP
                8'hB5:  state <= ZERO;      // LDA ZP,X
                8'hA1:  state <= IND0;      // LDA (ZP,X)
                8'hB2:  state <= IND0;      // LDA (ZP)
                8'hB1:  state <= IND0;      // LDA (ZP),Y
                8'hA9:  state <= IMM0;      // LDA #IMM0
                8'h48:  state <= PUSH;      // PUSH
                8'h68:  state <= PULL;      // PULL
            endcase
        IND0:   state <= IND1;
        IND1:   state <= IND2;      //
        IND2:   state <= BACK;
        IMM0:   state <= SYNC;
        ABS0:   state <= ABS1;
        ZERO:   state <= rmw ? RDWR : BACK;
        ABS1:   state <= ind ? ABS0 : 
                         jmp ? SYNC : BACK;
        RDWR:   state <= BACK;
        BACK:   state <= SYNC;
        PULL:   state <= BACK;
        PUSH:   state <= BACK;
        RTS0:   state <= RTS1;
        RTS1:   state <= RTS2;
        RTS2:   state <= SYNC; 
        JSR0:   state <= JSR1;
        JSR1:   state <= JSR2;
        JSR2:   state <= ABS1;
        BRK0:   state <= BRK1;
        BRK1:   state <= BRK2;
        BRK2:   state <= BRK3;
        BRK3:   state <= ABS0;
        RTI0:   state <= RTI1;
        RTI1:   state <= RTI2;
        RTI2:   state <= RTI3;
        RTI3:   state <= SYNC;
        COND:   state <= SYNC;
    endcase

`ifdef SIM
reg [31:0] statename;

always @(*)
    case( state )
        INIT: statename = "INIT";
        SYNC: statename = "SYNC";
        BACK: statename = "BACK";
        IMM0: statename = "IMM0";
        DATA: statename = "DATA";
        IND0: statename = "IND0";
        IND1: statename = "IND1";
        IND2: statename = "IND2";
        ABS0: statename = "ABS0";
        ABS1: statename = "ABS1";
        PULL: statename = "PULL";
        PUSH: statename = "PUSH";
        ZERO: statename = "ZERO";
        RDWR: statename = "RDWR";
        RTS0: statename = "RTS0";
        RTS1: statename = "RTS1";
        RTS2: statename = "RTS2";
        JSR0: statename = "JSR0";
        JSR1: statename = "JSR1";
        JSR2: statename = "JSR2";
        BRK0: statename = "BRK0";
        BRK1: statename = "BRK1";
        BRK2: statename = "BRK2";
        BRK3: statename = "BRK3";
        RTI0: statename = "RTI0";
        RTI1: statename = "RTI1";
        RTI2: statename = "RTI2";
        RTI0: statename = "RTI3";
        COND: statename = "COND";
    endcase
`endif

endmodule
