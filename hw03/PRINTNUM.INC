; Input AX: unsigned 16-bit value. Clobbers AX, BX, CX, DX.
PrintDec PROC NEAR
    mov bx,10
    xor cx,cx
split_digits:
    xor dx,dx               ; DIV consumes DX:AX, not AX alone.
    div bx
    push dx                 ; Save least-significant digits first.
    inc cx
    or ax,ax
    jnz split_digits
emit_digits:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop emit_digits
    mov dl,0Dh
    mov ah,02h
    int 21h
    mov dl,0Ah
    int 21h
    ret
PrintDec ENDP
