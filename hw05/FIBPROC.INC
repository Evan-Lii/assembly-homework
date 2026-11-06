; Input AX=n (0..100). Return SI=&memo[n][0].
; Preserve AX/BX/CX/DX/DI/BP; SI is the return value. Flags may change.
Fib PROC NEAR
    push bp
    mov bp,sp
    push ax                 ; Original n at SS:[BP-2], protected across recursion.
    push bx
    push cx
    push dx
    push di
    mov ax,sp
    cmp ax,min_sp
    jae measured
    mov min_sp,ax
measured:
    mov bx,[bp-2]
    cmp ready[bx],0
    jne fib_return
    mov ax,bx
    dec ax
    call Fib                ; Genuine recursive F(n-1).
    push si                 ; Keep its pointer while the second call reuses SI.
    mov ax,[bp-2]
    sub ax,2
    call Fib                ; Recursive F(n-2); memoization avoids recomputation.
    pop bx                  ; BX=&F(n-1), SI=&F(n-2).
    mov ax,[bp-2]
    mov dx,DIGITS
    mul dx                  ; n*21 <= 2100, fits a 16-bit offset.
    mov di,OFFSET memo
    add di,ax
    xor dx,dx               ; DL=decimal carry, 0 or 1.
    mov cx,DIGITS
add_digits:
    mov al,[bx]
    add al,[si]
    add al,dl               ; At most 9+9+1=19.
    xor dl,dl
    cmp al,10
    jb store_digit
    sub al,10
    inc dl
store_digit:
    mov [di],al
    inc bx
    inc si
    inc di
    loop add_digits
    mov bx,[bp-2]
    mov ready[bx],1
fib_return:
    mov ax,[bp-2]
    mov bx,DIGITS
    mul bx
    mov si,OFFSET memo
    add si,ax
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
Fib ENDP
