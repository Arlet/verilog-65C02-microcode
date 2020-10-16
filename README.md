# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA

### Cycle counts
For purpose of minimizing design, I did not keep the original cycle count. Instead, some
of the dead cycles were removed.

- implied instructions only take a single cycle (except for PHx/PLx which take 3). 
- ZP, X takes 3 cycles (same as ZP). The X offset is added at the same time.
- (ZP,X) takes 5 cycles
- DEC ZP takes 4 cycles, as does DEC ZP,X. DEC ABS takes 5 cycles.
- no penalty for page boundary crossing.
- JSR takes 5 cycles, RTS takes 4.

In fact, the only redundant cycles are in the implied single byte push/pull instructions (PHA/PLA and friends). 
These instructions fetch the next opcode, perform the stack access, and then fetch next opcode again.

Have fun. 
