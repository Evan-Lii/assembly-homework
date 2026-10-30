; Input DL = character. Restore AX changed by DOS function 02h.
PutChar PROC NEAR
    push ax
    mov ah,02h
    int 21h
    pop ax
    ret
PutChar ENDP

; Input BH = row, BL = column, both 1..9. Preserve caller registers.
PrintError PROC NEAR
    push ax
    push bx
    push cx
    push dx
    push si
    mov dl,bh
    add dl,'0'
    call PutChar
    mov dl,' '
    call PutChar
    mov dl,bl
    add dl,'0'
    call PutChar
    mov si,OFFSET error_text ; Reuse caller's table cursor for the message.
    mov cx,error_len        ; Reuse caller's inner-loop counter.
message_loop:
    mov dl,[si]             ; DS:[SI], no assumption about the direction flag.
    call PutChar
    inc si
    loop message_loop
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintError ENDP
