org 100h

.data           			;variable declaration
     n1 db "Enter 1st no: $"
     n2 db 10d, "Enter 2nd no: $"
     msg db 10d, "Result: $"

.code    
      mov ax, @data
      mov ds,ax
      
      mov ah, 09h       ;print/display on the screen
      mov dx,offset n1  ;takes the address of dx register
      int 21h           
      
      mov ah, 01h
      int 21h         ; read char 
      mov cl,al       ; stores char to cl
      
      mov ah,09h   
      mov dx, offset n2
      int 21h   
      
      mov ah,01h
      int 21h
      mov dl,al       ; stores char to dl
      
      sub cl,30h      ; conversion char to no
      sub dl,30h
      
      mov ah,09h
      mov dx,offset msg
      int 21h
      
      add dl,cl
      add dl,30h      ; conversion no to char
      mov ah,02h
      int 21h         ; output
      
ret
