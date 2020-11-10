# File automatically generated from microcode.hex
note that '<=' operator means that the results are stored at the end of the clock cycle, so they are
valid on the next row. The '=' operator works immediately.
the 'mod' column refers to the address mode. It is a 4 bit number, and encodes the AB, AH and PC columns
This means that you sometimes see useless loads in PC and AH.

If there is a register calculation in the bottom right corner without a destination register, it means
that the results are only calculated to set the flags.

If flags are modified, the default source is the ALU. If not, then it is mentioned explicitly.
If the source of a flag is 'M<n>' this can be a bit from the instruction, or a bit loaded from memory

Each microcode sequence starts with the dispatched opcode. Since it takes one cycle to fetch the opcode
from memory, and another cycle to look it up in the microcode ROM, the value on the DB is always equal to
the first operand byte (or the next instruction). In the last cycle of each instruction, the next
instruction is loaded, and AB is advanced to the byte after that. In the same cycle the flags are also updated
### 69 : ADC #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 65 : ADC ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 75 : ADC ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 6D : ADC ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 7D : ADC ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 79 : ADC ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 72 : ADC (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 61 : ADC (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 71 : ADC (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 29 : AND #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 25 : AND ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 35 : AND ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 2D : AND ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 3D : AND ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 39 : AND ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 32 : AND (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 21 : AND (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 31 : AND (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 0A : ASL A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=ASL A |

Flags update: C N Z

### 06 : ASL ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 16 : ASL ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 0E : ASL ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 1E : ASL ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 90 : BCC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### B0 : BCS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### F0 : BEQ
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 89 : BIT #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 24 : BIT ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 34 : BIT ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 2C : BIT ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 3C : BIT ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 30 : BMI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### D0 : BNE
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 10 : BPL
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 80 : BRA
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 00 : BRK
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 9 | AB<={01,S}    | AH<=DB | PC<=AB+1 |          | M<=DB | S<=S-1   |
| 8 | AB<={01,S}    |        |          | DO=PCH   | M<=DB | S<=S-1   |
| 8 | AB<={01,S}    |        |          | DO=PCL   | M<=DB | S<=S-1   |
| f | AB<=BRK       |        |          | DO=P     | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: I<=1 D<=0

### 50 : BVC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 70 : BVS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 18 : CLC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: C

### D8 : CLD
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: D<=M5

### 58 : CLI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: I<=M5

### B8 : CLV
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M   |

Flags update: V

### C9 : CMP #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### C5 : CMP ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D5 : CMP ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### CD : CMP ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### DD : CMP ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D9 : CMP ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D2 : CMP (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### C1 : CMP (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D1 : CMP (ZP), Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### E0 : CPX #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    X-M   |

Flags update: C N Z

### E4 : CPX ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    X-M   |

Flags update: C N Z

### EC : CPX ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    X-M   |

Flags update: C N Z

### C0 : CPY #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    Y-M   |

Flags update: C N Z

### C4 : CPY ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    Y-M   |

Flags update: C N Z

### CC : CPY ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    Y-M   |

Flags update: C N Z

### 3A : DEC A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-1   |

Flags update: N Z

### C6 : DEC ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### D6 : DEC ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### CE : DEC ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### DE : DEC ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### CA : DEX
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=X-1   |

Flags update: N Z

### 88 : DEY
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=Y-1   |

Flags update: N Z

### 49 : EOR #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 45 : EOR ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 55 : EOR ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 4D : EOR ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 5D : EOR ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 59 : EOR ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 52 : EOR (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 41 : EOR (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 51 : EOR (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 1A : INC A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+1   |

Flags update: N Z

### E6 : INC ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### F6 : INC ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### EE : INC ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### FE : INC ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### E8 : INX
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=X+1   |

Flags update: N Z

### C8 : INY
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=Y+1   |

Flags update: N Z

### 4C : JMP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 6C : JMP (IND)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 7C : JMP (IND,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 20 : JSR
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 9 | AB<={01,S}    | AH<=DB | PC<=AB+1 |          | M<=DB | S<=S-1   |
| 8 | AB<={01,S}    |        |          | DO=PCH   | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=PCL   | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### A9 : LDA #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### A5 : LDA ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B5 : LDA ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### AD : LDA ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### BD : LDA ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B9 : LDA ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B2 : LDA (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### A1 : LDA (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B1 : LDA (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### A2 : LDX #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### A6 : LDX ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### B6 : LDX ZP,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### AE : LDX ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### BE : LDX ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### A0 : LDY #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### A4 : LDY ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### B4 : LDY ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### AC : LDY ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### BC : LDY ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### 4A : LSR A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=LSR A |

Flags update: C N Z

### 46 : LSR ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 56 : LSR ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 4E : LSR ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 5E : LSR ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### EA : NOP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 09 : ORA #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 05 : ORA ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 15 : ORA ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 0D : ORA ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 1D : ORA ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 19 : ORA ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 12 : ORA (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 01 : ORA (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 11 : ORA (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 48 : PHA
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 08 : PHP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=P     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### DA : PHX
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 5A : PHY
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 68 : PLA
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### 28 : PLP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N<=M7 Z<=M1 V<=M6 I<=M2 D<=M3

### FA : PLX
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### 7A : PLY
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### 2A : ROL A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=ROL A  |

Flags update: C N Z

### 26 : ROL ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 36 : ROL ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 2E : ROL ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 3E : ROL ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 6A : ROR A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=ROR A  |

Flags update: C N Z

### 66 : ROR ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 76 : ROR ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 6E : ROR ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 7E : ROR ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: N Z

### 40 : RTI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          |       | S<=S+1   |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N<=M7 Z<=M1 V<=M6 I<=M2 D<=M3

### 60 : RTS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 2 | AB<={DB,AH}+1 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### E9 : SBC #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### E5 : SBC ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F5 : SBC ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### ED : SBC ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### FD : SBC ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F9 : SBC ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F2 : SBC (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### E1 : SBC (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F1 : SBC (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### 38 : SEC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    0-1   |

Flags update: C

### F8 : SED
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: D<=M5

### 78 : SEI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: I<=M5

### 85 : STA ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 95 : STA ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 8D : STA ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 9D : STA ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 99 : STA ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 92 : STA (ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 81 : STA (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 91 : STA (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 86 : STX ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 96 : STX ZP,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 8E : STX ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 84 : STY ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 94 : STY ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 8C : STY ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 64 : STZ ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 74 : STZ ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 9C : STZ ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 9E : STZ ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### AA : TAX
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=A     |

Flags update: N Z

### A8 : TAY
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=A     |

Flags update: N Z

### 14 : TRB ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=~A&M  |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 1C : TRB ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=~A&M  |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 04 : TSB ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A\|M   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 0C : TSB ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A\|M   |       |          |
| c | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### BA : TSX
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=S     |

Flags update: N Z

### 8A : TXA
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=X     |

Flags update: N Z

### 9A : TXS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | S<=X     |

Flags update:

### 98 : TYA
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=Y     |

Flags update: N Z

