; Print a-z with conditional jumps instead of LOOP.
.MODEL SMALL
.STACK 100h
.CODE
start:
    mov bl, 'a'
    mov cx, 2
row_loop:
    push cx                 ; Preserve the outer counter.
    mov cx, 13
char_loop:
    mov dl, bl
    mov ah, 02h
    int 21h
    inc bl
    cmp cx, 1
    je no_space
    mov dl, ' '
    mov ah, 02h
    int 21h
no_space:
    dec cx                  ; DEC sets ZF when the count reaches zero.
    jnz char_loop           ; Repeat the inner loop while ZF = 0.
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    int 21h
    pop cx
    dec cx
    jnz row_loop            ; Repeat the outer loop while ZF = 0.
    mov ax, 4C00h
    int 21h
END start
