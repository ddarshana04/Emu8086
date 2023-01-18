.model large 

.data
 N1 db "enter first number: $"
 N2 db 10,13,"enter second number: $"
 MSG db 10,13,"Result after swapping: $"   

.code    
MOV AX, @data
MOV DS,AX
MOV AH,09H
MOV DX, OFFSET N1
INT 21H

MOV AH,01H  ;takes input
INT 21H
MOV BL,AL  ;stores input

MOV AH,09H
MOV DX,OFFSET N2
INT 21H

MOV AH,01H
INT 21H
MOV CL,AL

MOV DL,0
MOV CL,BL
MOV BL,AL
MOV AH,09H
MOV DX, OFFSET MSG
INT 21H 

MOV AH,02H
MOV DL,BL
INT 21H
 

MOV AH,02H
MOV DL,CL
INT 21H  

MOV AH, 4CH
INT 21H
END

