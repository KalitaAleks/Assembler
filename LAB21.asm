            
.model small

.data

a dw ?
b dw ?
c dw ?
d dw ?
x dw ?
y dw ?
i db 0
res_len db 0
msg db "RESULT:$" 
hello db "Vvedite Chislo:",10,13,"$"
end_str db 10,13,"$"
.code
  mov ax,@data
  mov ds,ax

start:         
    mov dx, offset hello
    mov ah, 09h
    int 21h
    mov ah,01h  ; add input from screen
    int 21h 
    sub al,30h  ; get number from character
    mov ah,0  
    mov bx,10
    inc i       ;i=i+1
    mov cx,ax
Loopproc: mov ah,01h
    int 21h 
    cmp al,0dh  ; if put Enter
    je Endproc      ; go to finish
    sub al,30h  ; get number from character
    cbw         ; extend to word
    xchg ax,cx  ; move ax - previous, cx - next numbers
    mul bx      ; ax*10
    add cx,ax   ; cx=ax*10+cx
    jmp Loopproc    ; start loop again
Endproc: 
    call print_endproc              
    cmp i, 1
    je scanfA
    cmp i, 2
    je scanfB
    cmp i, 3
    je scanfC 
    cmp i, 4
    je scanfD
    cmp i,5
    je scanfX
    cmp i,6
    je scanfY  
scanfA:
    mov a, cx
    jmp start
    ret
scanfB:
    mov b, cx
    jmp start
    ret
scanfC:
    mov c, cx
    jmp start
    ret
scanfD:
    mov d, cx
    jmp start
    ret 
scanfX:
    mov x,cx
    jmp start
    ret
scanfY:
 mov y,cx
 call calculation
 mov dx, offset msg
 mov ah,09h
 int 21h
 xor ax,ax
 xor dx,dx
 mov ax,cx
 xor cx,cx
 mov di,0
 mov bx,10        
decproc:    
    inc cx          
    xor dx, dx
    mov bx, 10
    div bx
    push dx
    cmp ax, 0
    jne decproc
print:          
    mov ah, 02h     
    xor dx, dx
    pop dx
    add dx, '0'
    int 21h
    loop print
quit:
    mov ah, 04Ch
    mov al, 0       
    int 21h
    ret
    
calculation:
    ;add +
    ;mul *
    ;sub -
    ;div /
    ;neg negative
    ;inc +1
    ; ((a*x)div (b*x*y)) div x
    xor dx,dx
    mov ax, x
    mul x
    mul a
    mov cx,a
    xchg ax,cx
    mul b
    mul x
    mul y
    mov cx,b
    xchg ax,cx
    xor dx,dx
    div a
    xor dx,dx
    div b
    mov cx,c
   mov cx,d
   xor dx,dx
   div c
   xor dx,dx
   div d
   add ax,cx
    ret 
	   

  print_endproc: 
    mov dx, offset end_str
    mov ah, 09h
    int 21h 
    ret
	end