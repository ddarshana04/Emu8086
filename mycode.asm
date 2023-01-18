; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.MODEL SMALL
.DATA

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
MOV [SI],AL

MOV AH,01H
INT 21H
SUB AL,30H
MOV [SI+1],AL

MOV AH,01H
INT 21H
SUB AL,30H
MOV [SI+2],AL


MOV DX,OFFSET msg2
MOV AH,09H
INT 21H

MOV AH,01H
INT 21H
SUB AL,30H
MOV [DI],AL

MOV AH,01H
INT 21H
SUB AL,30H
MOV [DI+1],AL 

MOV AH,01H
INT 21H
SUB AL,30H
MOV [DI+2],AL
 
 
MOV CL,[SI]

MOV AH,09H
MOV DX,OFFSET msg3
INT 21H
   
   
L1:MOV AL,[SI]
   ADD AL,[DI]
   
   ADD AL,30H
   MOV BL,AL 
   
   MOV AH,02H
   MOV DL,BL
   INT 21H
   
   INC SI
   INC DI
   
   LOOP L1
   
   END

ret