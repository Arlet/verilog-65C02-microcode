# 65C02
A verilog model of the 65C02 CPU designed to fit in tiny space on FPGA. The code is completely
rewritten from scratch optimized for 6-input LUTs, specifically targeting Xilinx Spartan 6.  

* cpu.v module is the top level. 
* alu.v implements the ALU
* abl.v implements the lower 8 bits of the address bus.
* abh.v implements the upper 8 bits of the address bus.
* ctl.v does the instruction decoding and generation of all control signals.
* regfile.v has the register file.
* microcode.v implements a 512x32 bit ROM with the microcode.

