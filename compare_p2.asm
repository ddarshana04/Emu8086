.model large 

.data
  N1 db "enter first number: $"
  N2 db 10d,"enter second number: $"
  MSG DB "BOTH ARE EQUAL $"
  MSG1 DB "N1 IS LESS THAN N2 $" 
  MSG2 DB "N1 IS GREATER THAN N2 $"

.code
   MOV AX, @data
   MOV DS,AX
   MOV AH,N1
   MOV CH,N2
   CMP AH,CH
   JE L1      ;IF AH AND CH ARE EQUAL 
   JB L2      ;IF AH IS LESS THAN CH 
   JA L3      ;IF AH IS GREATER THAN CH    
   
L1:
   MOV DX, OFFSET MSG
   MOV AH,09H        ;PRINT THE MSG STDOUT
   INT 21H
   RET

L2:
   MOV DX, OFFSET MSG1
   MOV AH,09H          ;PRINT THE MSG STDOUT
   INT 21H
   RET

L3:
   MOV DX, OFFSET MSG2
   MOV AH,09H
   INT 21H
   RET
END
