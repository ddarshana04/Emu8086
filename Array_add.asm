org 100h

.MODEL SMALL

.DATA
    num1 DB 3 DUP (0)
    num2 DB 3 DUP (0)

    msg1 DB 10,13,10H,"Enter Values of Array1 : $"
    msg2 DB 10,13,10H,"Enter Values of Array2 : $"
    msg3 DB 10,13,10H,"Sum of Array : $"

.CODE 

MOV AX,@DATA
MOV DS,AX

MOV DX,OFFSET msg1
MOV AH,09H
INT 21H

MOV AH,01H
INT 21H
SUB AL,30H
MOV num1,AL

MOV AH,01H
INT 21H
SUB AL,30H
MOV num1+1,AL

MOV AH,01H
INT 21H
SUB AL,30H
MOV num1+2,AL


MOV DX,OFFSET msg2
MOV AH,09H
INT 21H

MOV AH,01H
INT 21H
SUB AL,30H
MOV num2,AL

MOV AH,01H
INT 21H
SUB AL,30H
MOV num2+1,AL 

MOV AH,01H
INT 21H
SUB AL,30H
MOV num2+2,AL

LEA SI,num1      ;set offset address of num1
LEA DI,num2      ;set offset address of num2
 
MOV CX,3

MOV AH,09H
MOV DX,OFFSET msg3
INT 21H

L1:MOV AL,[SI]  ;move value of [si] in al
   ADD AL,[DI]
   
   ADD AL,30H
   MOV BL,AL 
   
   MOV AH,02H
   MOV DL,BL
   INT 21H
   
   INC SI       ;increment si array pointer 
   INC DI       ;increment di array pointer 
   
   LOOP L1
   
   END

ret