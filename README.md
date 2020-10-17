# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA. The code is completely
rewritten from scratch optimized for 6-input LUTs, specifically targeting Xilinx Spartan 6.  

Unlike my previous verilog-6502, this core targets asynchronous memories. 

## Code
Code is not complete. This is a work in progress.

### Cycle counts
For purpose of minimizing design, I did not keep the original cycle count. Instead all strictly unnecessary
("dead") cycles have been removed.

- implied instructions only take a single cycle (except for push/pull which take 2). 
- ZP,X takes 3 cycles (same as ZP). The X offset is added at the same time.
- (ZP,X) takes 5 cycles
- DEC ZP takes 4 cycles, as does DEC ZP,X. DEC ABS takes 5 cycles.
- no penalty for page boundary crossings.
- branches are always 2 cycles, even if branch is taken
- JMP takes 3 cycles (5 cycles for indirect)
- JSR takes 5 cycles, RTS takes 4.

Have fun. 
