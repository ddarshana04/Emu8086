.model small 
 
.data
	n1 db ?
	n2 db ?
	q db ?
	r db ?
	msg1 db 10,13,'enter dividend: $' 
	msg2 db 10,13,'enter divisor: $'
	qu db 10,13,'Quotient: $'   
	rem db 10,13,'Reminder: $'   
	
	;10 indicates line feed control -> moves the cursor to the next line  
	;13 indicates carriage return code -> moves the cursor to the start of line  
     
.code
mov ax,@data 
mov ds,ax		  ;initialize data segment  

lea dx,msg1       ;lea used to load the address of operand into the register dx
mov ah,9
int 21h

mov ah,1 	   ;01h -> STDIN
int 21h
sub al,30h     ;conv char to no
mov n1,al  

lea dx,msg2
mov ah,9	   ;01h -> STDOUT
int 21h

mov ah,1
int 21h
sub al,30h
mov n2,al

mov al,n1    ;loading denominator  in al
mov ah,0
div n2       ;divide n2 by n1

mov q,al
mov r,ah

mov ah,9
lea dx,qu
int 21h

mov ah,2
mov bl,q  
add bl,30h
mov dl,bl
int 21h  

mov ah,9
lea dx,rem
int 21h

mov ah,2 		;displays current value on screen
mov bl,r 
add bl,30h
mov dl,bl
int 21h 
END 
ret
