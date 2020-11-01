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
wire [7:0] DB = DI;                     // data bus low (alias for DB)

reg [7:0] M;                            // registered value of DB

/*
 * Address Bus signals 
 */

wire [12:0] ab_op;
wire inc_pc = ab_op[12];                // set if PC needs increment
wire pcl_co;                            // carry out from PCL
wire ld_pc = ab_op[11];                 // load enable for PC 
wire ld_ahl = ab_op[10];                // load enable for AHL
wire [3:0] abh_op = ab_op[9:6];         // ABH operation
wire [4:0] abl_op = ab_op[5:1];         // ABL operation
wire abl_ci = ab_op[0];                 // ABL carry in
wire abl_co;                            // ABL carry out
wire abh_ci = abl_co;

wire [1:0] do_op;                       // select for Data Output
wire ld_m = ~do_op[0];                  // load enable for M register
wire adj_m = do_op[1];                  // use M for BCD adjust

/* 
 * ALU Signals
 */
wire alu_v;                             // ALU overflow output
wire alu_co;                            // ALU carry out
wire [6:0] alu_op;                      // ALU operation
wire [7:0] alu_out;                     // ALU output
reg alu_ci;                             // ALU carry in 
reg alu_si;                             // ALU shift in
wire adjh;                              // BCD adjust high
wire adjl;                              // BCD adjust low 

/*
 * Flags and flag updates
 */
wire sync;                              // start of new instruction
wire [9:0] flags;                       // flag control bits
reg cond;                               // condition code
reg N, V, D, I, Z, C;                   // processor status flags 
wire B;

wire [7:0] P = { N, V, 1'b1, B, D, I, Z, C };

/*
 * Register file signals
 */

wire [6:0] reg_op;
wire [7:0] R;

/*
 * Register file 
 */
regfile regfile(
    .clk(clk),
    .op(reg_op),
    .DI(alu_out),
    .DO(R) );

/*
 * ABL (Address Bus Low) logic
 */
abl abl(
    .clk(clk),
    .CI(abl_ci),
    .CO(abl_co),
    .cond(cond),
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
    .CI(abh_ci),
    .op(abh_op) ,
    .ld_pc(ld_pc),
    .inc_pc(pcl_co),
    .ADH(ADH),
    .PCH(PCH),
    .DB(DB)
);


/*
 * M register update. The M register holds the most
 * recent data on the bus. It feeds into the ALU, 
 * and also into flag updates.
 */

wire l = adjl;
wire h = adjh;

always @(posedge clk)
    if( sync )
        M <= DB;
    else if( ld_m )
        M <= adj_m ? {1'b0, h, h, 2'b0, l, l, 1'b0 } : DB;

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
    .adjh(adjh),
    .adjl(adjl),
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
    .reg_op(reg_op),
    .ab_op(ab_op),
    .do_op(do_op),
    .I(I),
    .D(D),
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
            3'b001 : C <= alu_co_1;             // delayed ALU carry out 
            3'b010 : C <= alu_co_1 | alu_co;    // BCD carry
            3'b011 : C <= alu_co;               // ALU carry out
            3'b10? : C <= M[0];                 // PLP
        endcase

/*
 * update N(egative) flag and Z(ero) flag
 *
 * The N/Z flags share two control bits in flags[4:3]
 *
 * 00 - do nothing
 * 01 - BIT (N <= M7, Z <= alu_out)
 * 10 - PLP
 * 11 - N/Z <= alu_out
 *
 */
always @(posedge clk)
    if( sync )
        casez( flags[4:3] )
            2'b01 : N <= M[7];         // BIT (bit 7) 
            2'b10 : N <= M[7];         // PLP
            2'b11 : N <= alu_out[7];   // ALU N flag 
        endcase

/*
 * update Z(ero) flag
 */
always @(posedge clk)
    if( sync )
        casez( flags[4:3] )
            2'b01 : Z <= ~|(R & M);    // BIT  
            2'b10 : Z <= M[1];         // PLP
            2'b11 : Z <= ~|alu_out;    // ALU == 0 
        endcase

/*
 * update (o)V(erflow) flag
 *
 */
always @(posedge clk)
    if( sync )
        case( flags[8:7] )
            2'b01 : V <= alu_v;
            2'b11 : V <= M[6];        // BIT/PLP
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
 * branch condition. 
 */
always @(*)
    if( M[0] | M[1] | M[2] )  cond = 1;      // non-conditional instructions
    else casez( M[7:4] )
        4'b000?:        cond = ~N;     // BPL
        4'b001?:        cond = N;      // BMI
        4'b010?:        cond = ~V;     // BVC
        4'b011?:        cond = V;      // BVS
        4'b1000:        cond = 1;      // BRA
        4'b100?:        cond = ~C;     // BCC
        4'b101?:        cond = C;      // BCS
        4'b110?:        cond = ~Z;     // BNE
        4'b111?:        cond = Z;      // BEQ
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

wire [7:0] X = regfile.X;
wire [7:0] Y = regfile.Y;
wire [7:0] A = regfile.A;
wire [7:0] S = regfile.S;

always @( posedge clk ) begin
      if( !debug || cycle[10:0] == 0 )
      //if( !debug || cycle > 77600000 )
      $display( "%4d %s%s %b.%3H OP:%b AB:%h%h DB:%h AH:%h DO:%h PC:%h%h IR:%h SYNC:%b %s WE:%d R:%h M:%h ALU:%h CO:%h ADJ:%b%b S:%02x A:%h X:%h Y:%h P:%s%s%s%s%s%s %d F:%b",
        cycle, R_, Q_, ctl.control[21:20], ctl.pc,  
       ctl.ab_mode, abh.ABH, abl.ABL, DB, abl.AHL,  DO, PCH, PCL, IR, sync, opcode, WE, R, M, alu_out, alu_co, adjh, adjl,
       S, A, X, Y,  C_, D_, I_, N_, V_, Z_, cond, sync ? flags : 8'h0 );
      if( sync && IR == 8'hdb )
        $finish( );
end
`endif

endmodule
