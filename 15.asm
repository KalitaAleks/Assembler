.model small

.data                                   
a dw ?
b dw ?
c dw ?
d dw ?
e dw ?
x dw ?
i dw 0
res_len dw 0
msg dw "RESULT:", "$" 
hello dw "Vvedite Chislo:",10,13,"$"
end_str dw 10,13,"$"
buffer dw ?

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
Loopproc: 
mov ah,01h
    int 21h 
    cmp al,0dh  ; if put Enter
    je Endproc      ; go to finish
    sub al,30h  ; get number from character
    cbw         ; extend to word
   xchg ax,cx  ; move ax - previous, cx - next numbers
    mul bx      ; ax*10
   add cx,ax   ; cx=ax*10+cx
    jmp Loopproc    ; start loopproc again
Endproc: 
    call print_end              
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
scanfE:
    mov e, cx
    jmp start
    ret
scanfX:
    mov x, cx   
    call calculation
    mov dx, offset msg
    mov ah, 09h
    int 21h
    mov di, buffer
    push di
    xor ax,ax
    xor dx,dx
    mov ax, cx
    xor cx, cx
    mov di, 0 
    mov bx, 10 

decs:                
    inc cx          
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
    mov ah, 02h  
    int 21h
    loop print  
quit:
   mov ah, 8
    int 21h
    mov ah, 04Ch
    mov al, 0       
    int 21h
    ret   
calculation:
xor ax, ax  
mov ax, [d]
mul [x]
mov [d], ax
mov ax, [x]
mul [x]
mul [c]
mov [c], ax
mov ax, [x]
mul [x] 
mul [x]
mul [b]
mov [b], ax
mov ax, [x]
mul [x]
mul [x] 
mul [x] 
mul [a]
add ax,[ b]
add ax, [c]
add ax, [d]  
xor dx, dx
div [e]   
mov cx , ax
ret
print_end: 
    mov dx, offset end_str
    mov ah, 09h
    int 21h 
    ret   
    end