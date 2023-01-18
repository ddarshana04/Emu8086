.model small 
.data      
  n1 db "Enter 1st no: $"
  n2 db 10d, "Enter 2nd no: $"
  MSG db 10d, "Result: $" 
  ;10 -> ah = 1, al = 0
   
.code 
  mov ax,@data
  mov ds,ax   		;fix in ds
  mov ah,9
  int 21h  

  mov ah,1     
  int 21h  
  mov bl,al   		;store 1st no bl 
  sub bl,48

  mov dx,offset n2   ;taking address of n2 to dx
  mov ah,9  	     ;09h -> STDOUT
  int 21h            ;control goes to output screen
  
  mov ah,1 	    ;01h -> STDIN
  int 21h
  sub al,48   	    ;conv char to no

  mul bl   	;al = al*bl 
  aam      	;adjust ASCII values after multiplication

  add ah,48	;conv no to char
  add al,48

  mov bx, ax
  mov dx,offset MSG
  mov ah,9  
  int 21h    

  mov ah,2        ;current input/value displays on screen
  mov dl,bh
  int 21h 
 
  mov ah,2  
  mov dl,bl
  int 21h 
  hlt
end




