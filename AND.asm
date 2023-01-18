;logical operations btwn two 8-bit numbers 
org 100h

.data 
   n1 db ?
   n2 db ?
   num1 db 10d,"enter 1st number: $"
   num2 db 10d,"enter 2nd number: $"
   res1 db 10d,"Result of AND op: $"
   res2 db 10d,"Result of OR op: $"

.code
mov ax,@data
mov ds,ax    	;fix in ds

mov dx, offset num1    ;address of n1 to dx
mov ah,9             ;09h -> STDOUT
int 21h              ;control goes to output screen

mov ah,1             ;01h -> STDIN
int 21h 
sub al,48            ;conv char to no  
mov n1,al

mov dx, offset num2  ;address of n2 to dx
mov ah,9  	      
int 21h            

mov ah,1          
int 21h  
sub al,48  
mov n2,al        

mov al,n1
mov ah,n2

OR ah,al
mov al,ah

add al,48          ;conv no to char
mov bl,al

mov dx, offset res1
mov ah,9
int 21h

mov ah,2        ;current input/value displays on screen
mov dl,bl
int 21h

mov al,n1
mov ah,n2

and ah,al
mov al,ah

add al,48          ;conv no to char
mov bl,al

mov dx, offset res2
mov ah,9
int 21h

mov ah,2
mov dl,bl
int 21h

end

ret
