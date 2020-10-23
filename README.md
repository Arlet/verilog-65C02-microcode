# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA. The code is completely
rewritten from scratch optimized for 6-input LUTs, specifically targeting Xilinx Spartan 6.  

Unlike my previous verilog-6502, this core supports both asynchronous and synchronous memories. In order
to do that, the top-level "AD" signal represents the *next* address. When using external asynchronous memory,
you should register the "AD" signals on the IO block as follows: ("AB" are the pad names) 

    always @(posedge clock)
        AB <= AD;

## Design goals
The main design goal is to minimize the slice count.  The first version will probably use a block RAM 
for microcode. 

## Code
Code is not complete. This is a work in progress. 

* cpu.v module is the top level. 
* alu.v implements the ALU
* abl.v implements the lower 8 bits of the address bus.
* abh.v implements the upper 8 bits of the address bus.
* ctl.v does the instruction decoding and generation of all control signals.

## Status

* All NMOS 6502 instructions added, and part of the 65C02 instructions.
* Model passes Klaus Dormann's test suite for 6502 (with BCD disabled)
* RST and IRQ implemented.
* NMI/RDY not yet implemented.
* BCD support not yet implemented.

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
