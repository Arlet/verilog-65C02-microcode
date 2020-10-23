/*
 * verilog model of 65C02 CPU.
 *
 * (C) Arlet Ottens, <arlet@c-scape.nl>
 *
 */

module cpu( clk, RST, AD, DI, DO, WE, IRQ, NMI, RDY, debug );

input clk;              // CPU clock
input RST;              // RST signal
output [15:0] AD;       // address bus (combinatorial) 
input [7:0] DI;         // data bus input
output reg [7:0] DO;    // data bus output 
output WE;              // write enable
input IRQ;              // interrupt request
input NMI;              // non-maskable interrupt request
input RDY;              // Ready signal. Pauses CPU when RDY=0
input debug;            // debug for simulation

wire [7:0] ADH;                         // address bus high
wire [7:0] ADL;                         // address bus low 
wire [7:0] PCH;                         // program counter high
wire [7:0] PCL;                         // program counter low

assign AD = {ADH, ADL};

/*
 * databus
 */
reg [7:0] DO;                           // Data Out
wire [7:0] DB = DI;                     // data bus low (alias for DB)
reg [7:0] M;                            // registered value of DB

reg [7:0] regs[15:0];                   // register file


initial begin
    regs[0]  = 2;                       // X register 
    regs[1]  = 3;                       // Y register 
    regs[2]  = 8'h41;                   // A register
    regs[3]  = 8'hff;                   // S register
    regs[4]  = 8'hfe;                   // IRQ/BRK vector
    regs[5]  = 8'h01;                   // for INC
    regs[6]  = 8'hff;                   // for DEC
    regs[7]  = 8'h00;                   // Z register, always zero
    regs[8]  = 8'hfa;                   // NMI
    regs[9]  = 8'hfc;                   // RST
    regs[10] = 8'hfe;                   // BRK
end

wire [6:0] dp_op;                       //
wire [2:0] reg_wr = dp_op[6:4];         // register file select
wire [3:0] reg_rd = dp_op[3:0];         // register file select
wire [7:0] R = regs[reg_rd];            // read register

/*
 * Address Bus signals 
 */

wire [11:0] ab_op;
wire inc_pc = ab_op[11];                // set if PC needs increment
wire pcl_co;                            // carry out from PCL
wire ld_pc = ab_op[10];                 // load enable for PC 
wire ld_ahl = ab_op[9];                 // load enable for AHL
wire abh_ff = ab_op[8];                 // enable for AHB <= FF (vector page)
wire [2:0] abh_op = ab_op[7:5];         // ABH operation
wire [3:0] abl_op = ab_op[4:1];         // ABL operation
wire abl_ci = ab_op[0];                 // ABL carry in
wire abl_co;                            // ABL carry out
wire abh_ci = abh_op[2] ? abl_co : abh_op[1];

wire [1:0] do_op;                       // select for Data Output
wire ld_m = ~do_op[0];                  // load enable for M register

/* 
 * ALU Signals
 */
wire alu_v;                             // ALU overflow output
wire alu_co;                            // ALU carry out
wire [6:0] alu_op;                      // ALU operation
wire [7:0] alu_out;                     // ALU output
reg alu_ci;                             // ALU carry in 
reg alu_si;                             // ALU shift in

/*
 * Flags and flag updates
 */
wire sync;                              // start of new instruction
wire [7:0] flags;                       // flag control bits
reg cond;                               // condition code
reg N, V, D, I, Z, C;                   // processor status flags 
wire B;

wire [7:0] P = { N, V, 1'b1, B, D, I, Z, C };


/*
 * ABL (Address Bus Low) logic
 */
abl abl(
    .clk(clk),
    .CI(abl_ci),
    .CO(abl_co),
    .op(abl_op),
    .ld_ahl(ld_ahl),
    .ld_pc(ld_pc),
    .inc_pc(inc_pc),
    .pcl_co(pcl_co),
    .PCL(PCL),
    .ADL(ADL),
    .DB(DB),
    .REG(R)
);

/*
 * ABH (Address Bus High) logic
 */
abh abh(
    .clk(clk),
    .ff(abh_ff),
    .CI(abh_ci),
    .op(abh_op) ,
    .ld_pc(ld_pc),
    .inc_pc(pcl_co),
    .ADH(ADH),
    .PCH(PCH),
    .DB(DB)
);

/*
 * write register file. New data for any of the 
 * registers always comes from the ALU output.
 *
 * Registers 4 and up are read-only.
 */
always @(posedge clk)
    if( reg_wr < 4 )
        regs[reg_wr] <= alu_out;

/*
 * M register update. The M register holds the most
 * recent data on the bus. It feeds into the ALU, 
 * and also into flag updates.
 */
always @(posedge clk)
    if( ld_m )
        M <= DB;

/*
 * DO (Data Output) mux. The DO value goes out to
 * the data bus, but only if WE is asserted,
 */
always @(*)
    case( do_op )
        2'b00:          DO = alu_out;
        2'b01:          DO = P;
        2'b10:          DO = PCL;
        2'b11:          DO = PCH;
    endcase

/*
 * ALU carry in and shift in
 */
always @(*)
    case( alu_op[6:5] )
        2'b00:          {alu_si, alu_ci} = 2'b00;
        2'b01:          {alu_si, alu_ci} = 2'b01;
        2'b10:          {alu_si, alu_ci} = {C, 1'b0};
        2'b11:          {alu_si, alu_ci} = {1'b0, C};
    endcase

/*
 * ALU
 */
alu alu(
    .CI(alu_ci),
    .SI(alu_si),
    .R(R),
    .M(M),
    .op(alu_op[4:0]),
    .V(alu_v),
    .OUT(alu_out),
    .CO(alu_co) );

/*
 * Control. Generates all control signals.
 */
ctl ctl( 
    .clk(clk),
    .irq(IRQ),
    .reset(RST),
    .cond(cond),
    .sync(sync),
    .flags(flags),
    .alu_op(alu_op),
    .dp_op(dp_op),
    .ab_op(ab_op),
    .do_op(do_op),
    .I(I),
    .B(B),
    .WE(WE),
    .DB(DB) );

/*
 * update C(arry) flag
 */
wire plp = flags[2];

/*
 * the alu_co_1 signal is the ALU carry out, delayed
 * by one cycle. This is because in RMW instructions
 * such as ROL, we do an instruction fetch before 
 * setting the flags, which changes the alu_co.
 */
reg alu_co_1; 

always @(posedge clk)
    alu_co_1 <= alu_co;

always @(posedge clk)
    if( sync )
        casez( {plp, flags[1:0]} )
            3'b001 : C <= alu_co_1;     // delayed ALU carry out 
            3'b011 : C <= alu_co;       // ALU carry out
            3'b10? : C <= M[0];         // PLP
        endcase

/*
 * update N(egative) flag and Z(ero) flag
 *
 * The N/Z flags share two control bits in flags[4:3]
 *
 * 00 - do nothing
 * 01 - BIT (N <= M7, Z <= alu_out)
 * 10 - reserved
 * 11 - N/Z <= alu_out
 *
 */
always @(posedge clk)
    if( sync )
        casez( {plp, flags[4:3]} )
            3'b001 : N <= M[7];         // BIT (bit 7) 
            3'b011 : N <= alu_out[7];   // ALU N flag 
            3'b1?? : N <= M[7];         // PLP
        endcase

/*
 * update Z(ero) flag
 */
always @(posedge clk)
    if( sync )
        casez( {plp, flags[4:3]} )
            3'b0?1 : Z <= ~|alu_out;    // ALU == 0 
            3'b1?? : Z <= M[1];         // PLP
        endcase

/*
 * update (o)V(erflow) flag
 *
 * For the V flag, we take a peek at NZ flags to see 
 * if we're doing a BIT.
 */
always @(posedge clk)
    if( sync )
        casez( {plp, flags[7], flags[4:3]} )
            4'b0101 : V <= M[6];        // BIT
            4'b01?? : V <= alu_v;
            4'b1??? : V <= M[6];        // PLP
        endcase


/*
 * update I(nterrupt) flag and D(ecimal) flags
 *
 * The I/D flags share two control bits in flags[6:5]
 *
 * 00 - do nothing
 * 01 - CLI/SEI
 * 10 - CLD/SED
 * 11 - BRK
 */
always @(posedge clk)
    if( sync )
        casez( {plp, flags[6:5]} )
            3'b001 : I <= M[5];         // CLI/SEI 
            3'b011 : I <= 1;            // BRK
            3'b1?? : I <= M[2];         // PLP
        endcase

always @(posedge clk)
    if( sync )
        casez( {plp, flags[6:5]} )
            3'b010 : D <= M[5];         // CLD/SED 
          //3'b011 : D <= 0;            // clear D in BRK
            3'b1?0 : D <= M[3];         // PLP
        endcase

/*
 * branch condition. Only consider the case for set flags.
 * Inversion is done in the microcode sequencer.
 */
always @(*)
    casez( M[7:6] )
        2'b00:          cond = N;      // BMI
        2'b01:          cond = V;      // BVS
        2'b10:          cond = C;      // BCS
        2'b11:          cond = Z;      // BEQ
    endcase

/*
 * mnemonic opcode name
 */

`ifdef SIM
reg [7:0] IR;

always @(posedge clk)
    if( sync )
        IR <= DB;

reg [23:0] opcode;
always @*
    casez( IR )
            8'b0000_0000: opcode = "BRK";
            8'b0000_1000: opcode = "PHP";
            8'b0001_0010: opcode = "ORA";
            8'b0011_0010: opcode = "AND";
            8'b0101_0010: opcode = "EOR";
            8'b0111_0010: opcode = "ADC";
            8'b1001_0010: opcode = "STA";
            8'b1011_0010: opcode = "LDA";
            8'b1101_0010: opcode = "CMP";
            8'b1111_0010: opcode = "SBC";
            8'b011?_0100: opcode = "STZ";
            8'b1001_11?0: opcode = "STZ";
            8'b0101_1010: opcode = "PHY";
            8'b1101_1010: opcode = "PHX";
            8'b0111_1010: opcode = "PLY";
            8'b1111_1010: opcode = "PLX";
            8'b000?_??01: opcode = "ORA";
            8'b0001_0000: opcode = "BPL";
            8'b0001_1010: opcode = "INA";
            8'b000?_??10: opcode = "ASL";
            8'b0001_1000: opcode = "CLC";
            8'b0010_0000: opcode = "JSR";
            8'b0010_1000: opcode = "PLP";
            8'b001?_?100: opcode = "BIT";
            8'b001?_??01: opcode = "AND";
            8'b0011_0000: opcode = "BMI";
            8'b0011_1010: opcode = "DEA";
            8'b001?_??10: opcode = "ROL";
            8'b0011_1000: opcode = "SEC";
            8'b0100_0000: opcode = "RTI";
            8'b0100_1000: opcode = "PHA";
            8'b010?_??01: opcode = "EOR";
            8'b0101_0000: opcode = "BVC";
            8'b010?_??10: opcode = "LSR";
            8'b0101_1000: opcode = "CLI";
            8'b01??_1100: opcode = "JMP";
            8'b0110_0000: opcode = "RTS";
            8'b0110_1000: opcode = "PLA";
            8'b011?_??01: opcode = "ADC";
            8'b0111_0000: opcode = "BVS";
            8'b011?_??10: opcode = "ROR";
            8'b0111_1000: opcode = "SEI";
            8'b1000_0000: opcode = "BRA";
            8'b1000_1000: opcode = "DEY";
            8'b1000_?100: opcode = "STY";
            8'b1001_0100: opcode = "STY";
            8'b1000_1010: opcode = "TXA";
            8'b1001_0010: opcode = "STA";
            8'b100?_??01: opcode = "STA";
            8'b1001_0000: opcode = "BCC";
            8'b1001_1000: opcode = "TYA";
            8'b1001_1010: opcode = "TXS";
            8'b100?_?110: opcode = "STX";
            8'b1010_0000: opcode = "LDY";
            8'b1010_1000: opcode = "TAY";
            8'b1010_1010: opcode = "TAX";
            8'b101?_??01: opcode = "LDA";
            8'b1011_0000: opcode = "BCS";
            8'b101?_?100: opcode = "LDY";
            8'b1011_1000: opcode = "CLV";
            8'b1011_1010: opcode = "TSX";
            8'b101?_?110: opcode = "LDX";
            8'b1010_0010: opcode = "LDX";
            8'b1100_0000: opcode = "CPY";
            8'b1100_1000: opcode = "INY";
            8'b1100_?100: opcode = "CPY";
            8'b1100_1010: opcode = "DEX";
            8'b110?_??01: opcode = "CMP";
            8'b1101_0000: opcode = "BNE";
            8'b1101_1000: opcode = "CLD";
            8'b110?_?110: opcode = "DEC";
            8'b1110_0000: opcode = "CPX";
            8'b1110_1000: opcode = "INX";
            8'b1110_?100: opcode = "CPX";
            8'b1110_1010: opcode = "NOP";
            8'b111?_??01: opcode = "SBC";
            8'b1111_0000: opcode = "BEQ";
            8'b1111_1000: opcode = "SED";
            8'b111?_?110: opcode = "INC";
            8'b1101_1011: opcode = "STP";

            default:      opcode = "___";
    endcase

wire [7:0] B_ = B ? "B" : "-";
wire [7:0] C_ = C ? "C" : "-";
wire [7:0] D_ = D ? "D" : "-";
wire [7:0] I_ = I ? "I" : "-";
wire [7:0] N_ = N ? "N" : "-";
wire [7:0] V_ = V ? "V" : "-";
wire [7:0] Z_ = Z ? "Z" : "-";
wire [7:0] R_ = RST ? "R" : "-";
wire [7:0] Q_ = IRQ ? "I" : "-";

integer cycle;

always @( posedge clk )
    cycle <= cycle + 1;

wire [7:0] X = regs[0];                 // for simulator viewing
wire [7:0] Y = regs[1];                 // for simulator viewing
wire [7:0] A = regs[2];                 // for simulator viewing
wire [7:0] S = regs[3];                 // for simulator viewing

always @( posedge clk ) begin
      if( !debug || cycle[20:0] == 0 )
      $display( "%4d %s%s %b.%3H AD:%h AB:%h%h DB:%h AH:%h DO:%h PC:%h%h IR:%h SYNC:%b %s WE:%d R:%h M:%h ALU:%h CO:%h S:%02x A:%h X:%h Y:%h P:%s%s%s%s%s%s %d F:%b",
        cycle, R_, Q_, ctl.control[21:20], ctl.pc,  
       AD, abh.ABH, abl.ABL, DB, abl.AHL,  DO, PCH, PCL, IR, sync, opcode, WE, R, M, alu_out, alu_co, S, A, X, Y,  C_, D_, I_, N_, V_, Z_, cond, sync ? flags : 8'h0 );
      if( sync && IR == 8'hdb )
        $finish( );
end
`endif

endmodule
