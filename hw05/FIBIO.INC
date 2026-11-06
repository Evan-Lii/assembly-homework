PutChar PROC NEAR
    push ax
    mov ah,02h
    int 21h
    pop ax
    ret
PutChar ENDP

; SI points at 21 least-significant-first decimal digits. Preserve inputs.
PrintBig PROC NEAR
    push ax
    push cx
    push dx
    push si
    add si,DIGITS-1
    mov cx,DIGITS
skip_zero:
    cmp cx,1
    je emit_digit
    cmp BYTE PTR [si],0
    jne emit_digit
    dec si
    dec cx
    jmp skip_zero
emit_digit:
    mov dl,[si]
    add dl,'0'
    call PutChar
    dec si
    loop emit_digit
    pop si
    pop dx
    pop cx
    pop ax
    ret
PrintBig ENDP
