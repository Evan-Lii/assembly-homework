; Accumulate the result in a local word on the stack.
.MODEL SMALL
.STACK 100h
.CODE
start:
    push bp
    mov bp,sp
    sub sp,2                ; Reserve one word for the running total.
    mov WORD PTR [bp-2],0    ; BP-based addresses use SS by default.
    mov bx,1
    mov cx,100
sum_loop:
    add WORD PTR [bp-2],bx
    inc bx
    loop sum_loop
    mov ax,[bp-2]
    mov sp,bp               ; Release the local word and restore BP.
    pop bp
    call PrintDec
    mov ax,4C00h
    int 21h
INCLUDE PRINTNUM.INC
END start
