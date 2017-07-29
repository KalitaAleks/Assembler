.model small

.data
ten dw 10
a dw ?
b dw ?
c dw ?
d dw ?
x dw ?
e dw ?
q dw 1
result dw ?
i dw 0

file_name db 'test.txt',0
file_name_out db 'out.txt',0
s_error   db 'Error!',13,10,'$'
endline   db 13,10,'$'
buffer    dw 81             
handle    dw 1
buffer_out dw ?              

.code
  mov ax,@data
  mov ds,ax
start:
    mov ah,3Dh              
    xor al,al               
    mov dx, offset file_name        
    xor cx,cx               
    int 21h                 
    
    mov [handle],ax         
    
    ;read from file
    mov bx,ax               
    mov ah,3Fh              
    mov dx,buffer           
    mov cx,80               
    int 21h                 
    mov bx,buffer
    mov cx,ax
    xor ax,ax
    mov al,byte ptr [bx]
    sub al, 30h
    dec cx
    inc bx
strToNum:
    xor dx,dx
    mov dl,byte ptr [bx]
    cmp dl, 20h
    je Num
    mul ten
    mov dl,byte ptr [bx]
    inc bx
    sub dl, 30h
    add al, dl
    Loop strToNum 
Num:
    inc i
    inc bx
    cmp i, 1
    je scanfA
    cmp i, 2
    je scanfB
    cmp i, 3
    je scanfC
    cmp i, 4
    je scanfD
    cmp i, 5
    je scanfE
	cmp i, 6
	je scanfX
    ret
    
scanfA:
    mov a, ax
    xor ax,ax
    dec cx
    jmp strToNum
    ret
scanfB:
    mov b, ax
    xor ax,ax
    dec cx
    jmp strToNum
    ret
scanfC:
    mov c, ax
    xor ax,ax
    dec cx
    jmp strToNum
    ret
scanfD:
    mov d, ax
    xor ax,ax
    dec cx
    jmp strToNum
    ret
scanfE:  
    mov e, ax
    xor ax,ax
	dec cx
	jmp strToNum
    ret
	scanfX: 
mov x, ax
    xor ax,ax
    call calculation
    mov result, cx 
close_file:
    mov ah,3Eh              
    mov bx,[handle]         
    int 21h       
open_output:
    mov ah,3Dh
    mov al, 02
    mov dx, offset file_name_out        
    xor cx,cx               
    int 21h                  
    mov [handle],ax
    mov di, offset buffer_out
    push di
    xor ax,ax
    xor dx,dx
    mov ax, result
    xor cx, cx
decs:                
    inc cx
    inc si          
    xor dx, dx
    mov bx, 10
    div bx
    add dx, '0'
    push dx
    cmp ax, 0
    jne decs
print:          
    xor dx, dx
    pop dx
    mov [di],dx
    inc di
    loop print
    xor dx, dx
    mov byte ptr [di], '$'
    pop di
    xchg dx, di
    mov ah, 9
    int 21h
    
    mov bx,[handle]         
    mov ah,40h                             
    mov cx, si               
    int 21h                 
    jnc close_file_out          
    call error_msg          
 
close_file_out:
    mov ah,3Eh              
    mov bx,[handle]         
    int 21h                 
    jnc exit                
    call error_msg  
exit:
    mov ah,8                
    int 21h                 
    mov ax,4C00h            
    int 21h                 
 
;-------------------------------------------------------------------------------
;error message
error_msg:
    mov ah,9
    mov dx, offset s_error
    int 21h                
    ret

;-------------------------------------------------------------------------------
;calculation
calculation:
mov ax, d;
mul x;
mov d, ax;
mov ax, x;
mul x;
mul c;
mov c, ax;
mov ax, x;
mul x; 
mul x;
mul b;
mov b, ax;
mov ax, x;
mul x;
mul x; 
mul x; 
mul a;
add ax, b;
add ax, c;
add ax, d;
div e;
mov cx, ax
    ret
	end