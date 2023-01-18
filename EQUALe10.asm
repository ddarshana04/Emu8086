.model large 

.data
N1 db "enter first number: $"
N2 db 10d,"enter second number: $"
MSG1 db 10d,"numbers are equal$"
MSG2 db 10d,"numbers are not equal $"

.code
MOV AX, @data
MOV DS,AX
MOV AH,09H
MOV DX, OFFSET N1
INT 21H


MOV AH,01H
INT 21H
MOV BL,AL

MOV AH,09H
MOV DX,OFFSET N2
INT 21H

MOV AH,01H
INT 21H
MOV CL,AL

CMP BL,CL
JE EQ1
MOV AH,09H
MOV DX, OFFSET MSG2
INT 21H
JMP EXIT
 
EQ1: 
  MOV AH,09H
  MOV DX,OFFSET MSG1
  INT 21H

EXIT:
  MOV AH,4CH
  INT 21H  
  
END

