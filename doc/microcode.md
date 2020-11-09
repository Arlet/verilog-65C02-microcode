### 00 : BRK 

| mode   | AB          |   AB     |   PC      |  DO     |  M      |  REG    |
|--------|-------------|----------|-----------|---------|---------|---------|
|    [9] |AB<={01,S}   |   AH<=DB | PC<=AB+1  |         |   M<=DB |  S<=S-1 |
|    [8] |AB<={01,S}   |          |           | DO=PCH  |   M<=DB |  S<=S-1 |
|    [8] |AB<={01,S}   |          |           | DO=PCL  |   M<=DB |  S<=S-1 |
|    [f] |AB<=BRK      |          |           | DO=P    |   M<=DB |         |
|    [4] |AB<=AB+1     |   AH<=DB |           |         |   M<=DB |         |
|    [2] |AB<={DB,AH}+0|          | PC<=AB+1  |         |   M<=DB |         |
|    [4] |AB<=AB+1     |   AH<=DB |           |         |   M<=DB |         |

