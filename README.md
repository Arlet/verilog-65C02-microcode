# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA. The code is completely
rewritten from scratch optimized for 6-input LUTs, specifically targeting Xilinx Spartan 6.  


# Block diagram

![Image of block diagram](http://c-scape.nl/arlet/fpga/6502/schematic.png)

Unlike my previous verilog-6502, this core supports both asynchronous and synchronous memories. In order
to do that, the top-level "AD" signal represents the *next* address. When using external asynchronous memory,
you should register the "AD" signals on the IO block as follows: ("AB" are the pad names) 

    always @(posedge clock)
        if( RDY )
            AB <= AD;

When using synchronous memories, you need a separate read and write port ("Simple Dual Ported"), and use the AD signal for reading
(produce DI at the next cycle), and use AB for writing. Like this:

    always @(posedge clk)
        if( WE & RDY )
            mem[AB] <= DO;

    always @(posedge clk)
        if( RDY )
            DI <= mem[AD]

When using asynchronous memories, you just use AB for both reading and writing, and combine DI/DO on the data bus:

    assign DB = WE ? DO : 8'hZZ;
    assign DI = DB;

When using the RDY signal, please note that the unregistered 'AD' outputs are not guaranteed to be stable while RDY=0. For example, 
during a zeropage access, the DB input is fed back directly on the AD output. If you're deasserting RDY in your design, you must either
use the registered 'AB' that use the RDY as clock enable, shown above, or you must read the AD output only on the first cycle of RDY=0, 
and ignoring any changes while RDY is kept low.

## Design goals
The main design goal is to minimize the slice count.  The first version uses a block RAM 
for microcode. 

## Code
Code is complete. 

* cpu.v module is the top level. 
* alu.v implements the ALU
* abl.v implements the lower 8 bits of the address bus.
* abh.v implements the upper 8 bits of the address bus.
* ctl.v does the instruction decoding and generation of all control signals.
* regfile.v has the register file.
* microcode.v implements a 512x32 bit ROM with the microcode.

The Spartan6 directory uses Xilinx Spartan-6 specific instantiations. The generic directory has plain verilog that should run on any FPGA.

Code has been tested with Verilator. 

## Status

* All CMOS/NMOS 6502 instructions added (except for NOPs as undefined, Rockwell/WDC extensions)
* Model passes Klaus Dormann's test suite for 6502/65C02 (with BCD enabled)
* SYNC, RST, IRQ, RDY, NMI implemented.
* BCD support implemented using additional cycle. N/C/Z flags updated, V flag unaffected.

### Cycle counts
For purpose of minimizing design, I did not keep the original cycle
count. Most of the so-called dead cycles have been removed, except for
one cycle in the PHx/PLx instructions, where this would have been too messy.

| Instruction type | Cycles |
| :--------------: | :----: |
| Implied PHx/PLx  |   3    |
| RTS              |   4    |
| RTI              |   5    |
| BRK              |   7    |
| Other implied    |   1    |
| JMP Absolute     |   3    |
| JMP (Indirect)   |   5    |
| JSR Absolute     |   5    |
| branch           |   2    |
| Immediate        |   2    |
| Zero page        |   3    |
| Zero page, X     |   3    |
| Zero page, Y     |   3    |
| Absolute         |   4    |
| Absolute, X      |   4    |
| Absolute, Y      |   4    |
| (Zero page)      |   5    |
| (Zero page), Y   |   5    |
| (Zero page, X)   |   5    |

Add 1 cycle for any read-modify-write. There is no extra cycle for taken branches, page overflows, or for X/Y offset calculations.

### Example waveform
Here's an example of the 65C02 core taking a reset, loading the reset vector, and jumping to test code at $F800, where it does INX in a loop.

![Example waveform](http://c-scape.nl/arlet/fpga/6502/waveform.png?)


Have fun. 
