# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA. The code is completely
rewritten from scratch optimized for 6-input LUTs, specifically targeting Xilinx Spartan 6.  

Unlike my previous verilog-6502, this core supports both asynchronous and synchronous memories. In order
to do that, the top-level "AD" signal represents the *next* address. When using external asynchronous memory,
you should register the "AD" signals on the IO block as follows: ("AB" are the pad names) 

    always @(posedge clock)
        if( RDY )
            AB <= AD;

When using the RDY signal, please note that the unregistered 'AD' outputs are not guaranteed to be stable while RDY=0. For example, 
during a zeropage access, the DB input is fed back directly on the AD output. If you're deasserting RDY in your design, you must either
use the registered 'AB' that use the RDY as clock enable, shown above, or you must read the AD output only on the first cycle of RDY=0, 
and ignoring any changes while RDY is kept low.

## Design goals
The main design goal is to minimize the slice count.  The first version uses a block RAM 
for microcode. 

## Code
Code is not complete. This is a work in progress. 

* cpu.v module is the top level. 
* alu.v implements the ALU
* abl.v implements the lower 8 bits of the address bus.
* abh.v implements the upper 8 bits of the address bus.
* ctl.v does the instruction decoding and generation of all control signals.

The Spartan6 directory uses Xilinx Spartan-6 specific instantiations. The generic directory has plain verilog that should run on any FPGA.

Code has been tested with Verilator. 

## Status

* All CMOS/NMOS 6502 instructions added (except for NOPs as undefined, Rockwell/WDC extensions)
* Model passes Klaus Dormann's test suite for 6502/65C02 (with BCD disabled)
* RST, IRQ, RDY implemented.
* NMI not yet implemented.
* BCD support implemented using additional cycle. N/C/Z flags updated, V flag unaffected.

### Cycle counts
For purpose of minimizing design, I did not keep the original cycle
count. Most of the so-called dead cycles have been removed. In some cases,
this was too complicated, most notably when doing the implied push/pull
instructions, such as PHA and PLA.

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

Have fun. 
