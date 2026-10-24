; Input DL = character. AX and all other registers are preserved.
PutChar PROC NEAR
    push ax
    mov ah,02h
    int 21h
    pop ax
    ret
PutChar ENDP

; Input AX = unsigned word. Preserve AX, BX, CX, DX.
PrintDec PROC NEAR
    push ax
    push bx
    push cx
    push dx
    mov bx,10
    xor cx,cx
split_digits:
    xor dx,dx               ; Word DIV uses DX:AX.
    div bx
    push dx
    inc cx
    or ax,ax
    jnz split_digits
emit_digits:
    pop dx
    add dl,'0'
    call PutChar
    loop emit_digits
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintDec ENDP

; Input BH = row (1..9), BL = column (1..row).
; Preserve AX/BX/CX/DX. SI/DI/BP are not used. Flags are not preserved.
PrintCell PROC NEAR
    push ax
    push bx
    push cx
    push dx
    mov dl,bh
    add dl,'0'
    call PutChar
    mov dl,'*'
    call PutChar
    mov dl,bl
    add dl,'0'
    call PutChar
    mov dl,'='
    call PutChar
    mov al,bh
    mul bl                  ; AL * BL -> AX; maximum product is 81.
    call PrintDec
    cmp bl,bh
    je cell_done            ; No spaces after the last cell.
    mov cx,2
    cmp ax,10
    jae pad_cell
    inc cx                  ; Three spaces after a one-digit product.
pad_cell:
    mov dl,' '
    call PutChar
    loop pad_cell
cell_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintCell ENDP
