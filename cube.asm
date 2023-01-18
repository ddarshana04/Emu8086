.model small  
.data
    msg1 db 10,13,'Enter no: $'
    msg2 db 10,13,'cube: $'       
    n1 db ?
    n2 db ?
    n3 db ?  
    
.code
mov ax, @data
mov ds,ax  
lea dx,msg1
mov ah,9
int 21h

mov ah,1
int 21h
sub al,30h
mov n1,al

mov al,n1

mul al
mov bl,al

mov al,n1
mul bl
aam      

add ah,30h
add al,30h

mov n2,ah
mov n3,al
lea dx,msg2
mov ah,9
int 21h

mov ah,2
mov dl,n2
int 21h

mov ah,2
mov dl,n3
int 21h
END