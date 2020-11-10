# File automatically generated from microcode.hex
note that '<=' operator means that the results are stored at the end of the clock cycle, so they are
valid on the next row. The '=' operator works immediately.
the 'mod' column refers to the address mode. It is a 4 bit number, and encodes the AB, AH and PC columns
This means that you sometimes see useless loads in PC and AH.

If there is a register calculation in the bottom right corner without a destination register, it means
that the results are only calculated to set the flags.

If flags are modified, the default source is the ALU. If not, then it is mentioned explicitly.
If the source of a flag is 'M<n>' this can be a bit from the instruction, or a bit loaded from memory

### 00 : BRK
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 9 | AB<={01,S}    | AH<=DB | PC<=AB+1 |          | M<=DB | S<=S-1   |
| 8 | AB<={01,S}    |        |          | DO=PCH   | M<=DB | S<=S-1   |
| 8 | AB<={01,S}    |        |          | DO=PCL   | M<=DB | S<=S-1   |
| f | AB<=BRK       |        |          | DO=P     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: I<=1 D<=0

### 01 : ORA (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 04 : TSB ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A\|M   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 05 : ORA ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 06 : ASL ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 08 : PHP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=P     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 09 : ORA #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 0A : ASL A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=ASL A |

Flags update: C N Z

### 0C : TSB ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A\|M   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 0D : ORA ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 0E : ASL ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 10 : BPL
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 11 : ORA (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 12 : ORA (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 14 : TRB ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=~A&M  |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 15 : ORA (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 16 : ASL ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 18 : CLC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: C

### 19 : ORA ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 1A : INC A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+1   |

Flags update: N Z

### 1C : TRB ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=~A&M  |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 1D : ORA ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A\|M   |

Flags update: N Z

### 1E : ASL ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ASL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ASL M |

Flags update: C N Z

### 20 : JSR
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 9 | AB<={01,S}    | AH<=DB | PC<=AB+1 |          | M<=DB | S<=S-1   |
| 8 | AB<={01,S}    |        |          | DO=PCH   | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=PCL   | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 21 : AND (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 24 : BIT ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 25 : AND ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 26 : ROL ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROL M |

Flags update: C N Z

### 28 : PLP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N<=M7 Z<=M1 V<=M6 I<=M2 D<=M3

### 29 : AND #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 2A : ROL A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=ROL A  |

Flags update: C N Z

### 2C : BIT ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 2D : AND A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 2E : ROL ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROL M |

Flags update: C N Z

### 30 : BMI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 31 : AND (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 32 : AND (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 34 : BIT ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 35 : AND ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 36 : ROL ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROL M |

Flags update: C N Z

### 38 : SEC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    0-1   |

Flags update: C

### 39 : AND ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 3A : DEC A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-1   |

Flags update: N Z

### 3C : BIT ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: N<=M7 Z V<=M6

### 3D : AND ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A&M   |

Flags update: N Z

### 3E : ROL ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROL M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROL M |

Flags update: C N Z

### 40 : RTI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          |       | S<=S+1   |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N<=M7 Z<=M1 V<=M6 I<=M2 D<=M3

### 41 : EOR (ZP,X)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 45 : EOR ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 46 : LSR ZP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N Z

### 48 : PHA
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 49 : EOR #IMM
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 4A : LSR A
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=LSR A |

Flags update: C N Z

### 4C : JMP
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 4D : EOR ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 4E : LSR ABS
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N Z

### 50 : BVC
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 51 : EOR (ZP),Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 52 : EOR (ZP)
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
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

### 56 : LSR ZP,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N Z

### 58 : CLI
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: I<=M5

### 59 : EOR ABS,Y
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 5A : PHY
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 5D : EOR ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A^M   |

Flags update: N Z

### 5E : LSR ABS,X
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=LSR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    LSR M |

Flags update: C N Z

### 60 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 2 | AB<={DB,AH}+1 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 61 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 64 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 65 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 66 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROR M |

Flags update: C N Z

### 68 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### 69 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 6A : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=ROR A  |

Flags update: C N Z

### 6C : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 6D : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 6E : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROR M |

Flags update: C N Z

### 70 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 71 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 72 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 74 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 75 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 76 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROR M |

Flags update: C N Z

### 78 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: I<=M5

### 79 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 7A : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### 7C : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 7D : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A+M   |

Flags update: C N Z V

### 7E : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=ROR M |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    ROR M |

Flags update: C N Z

### 80 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 81 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 84 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 85 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 86 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 88 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=Y-1   |

Flags update: N Z

### 89 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A&M   |

Flags update: Z

### 8A : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=X     |

Flags update: N Z

### 8C : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 8D : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 8E : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 90 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 91 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 92 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 94 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=Y     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 95 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 96 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 98 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=Y     |

Flags update: N Z

### 99 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 9A : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | S<=X     |

Flags update:

### 9C : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 9D : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=A     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### 9E : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=0     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### A0 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### A1 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### A2 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### A4 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### A5 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### A6 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### A8 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=A     |

Flags update: N Z

### A9 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### AA : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=A     |

Flags update: N Z

### AC : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### AD : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### AE : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### B0 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### B1 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B2 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B4 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### B5 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### B6 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### B8 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M   |

Flags update: V

### B9 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### BA : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=S     |

Flags update: N Z

### BC : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=M     |

Flags update: N Z

### BD : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=M     |

Flags update: N Z

### BE : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### C0 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    Y-M   |

Flags update: C N Z

### C1 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### C4 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    Y-M   |

Flags update: C N Z

### C5 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### C6 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### C8 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | Y<=Y+1   |

Flags update: N Z

### C9 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### CA : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=X-1   |

Flags update: N Z

### CC : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    Y-M   |

Flags update: C N Z

### CD : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### CE : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### D0 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### D1 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D2 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D5 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### D6 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### D8 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: D<=M5

### D9 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### DA : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| b | AB<={01,S}    |        |  PC<=AB  |          | M<=DB | S<=S-1   |
| 1 | AB<=PC        |        |          | DO=X     | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### DD : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    A-M   |

Flags update: C N Z

### DE : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=M-1   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    M-1   |

Flags update: N Z

### E0 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    X-M   |

Flags update: C N Z

### E1 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### E4 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    X-M   |

Flags update: C N Z

### E5 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### E6 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### E8 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=X+1   |

Flags update: N Z

### E9 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### EA : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### EC : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    X-M   |

Flags update: C N Z

### ED : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### EE : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### F0 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 7 | AB<=COND      |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update:

### F1 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+Y |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F2 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+0 |        | PC<=AB+1 |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| a | AB<={DB,AH}+0 |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F5 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### F6 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 3 | AB<={00,DB}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

### F8 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |

Flags update: D<=M5

### F9 : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+Y |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### FA : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 5 | AB<={01,S+1}  | AH<=DB |  PC<=AB  |          | M<=DB | S<=S+1   |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | X<=M     |

Flags update: N Z

### FD : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 1 | AB<=PC        |        |          |          | M<=DB |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB | A<=A-M   |

Flags update: C N Z V

### FE : 
|mod|      AB       |   AH   |    PC    |    DO    |   M   |   REG    |
|---|---------------|--------|----------|----------|-------|----------|
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |          |
| 2 | AB<={DB,AH}+X |        | PC<=AB+1 |          | M<=DB |          |
| 0 | AB<=AB+0      |        |          |          | M<=DB |          |
| 1 | AB<=PC        |        |          | DO=1+M   |       |          |
| 4 | AB<=AB+1      | AH<=DB |          |          | M<=DB |    1+M   |

Flags update: N Z

