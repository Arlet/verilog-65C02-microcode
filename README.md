# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA. The code is completely
rewritten from scratch optimized for 6-input LUTs, specifically targeting Xilinx Spartan 6.  

Unlike my previous verilog-6502, this core targets asynchronous memories. 

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

### Cycle counts
For purpose of minimizing design, I did not keep the original cycle count. Most of the so-called
dead cycles have been removed. In some cases, this was too complicated, most notably when doing
the implied push/pull instructions, such as PHA and PLA. 

Have fun. 
