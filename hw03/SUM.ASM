; 8086 / MASM 5.x / DOS. Accumulate 1+...+100 in register AX.
.MODEL SMALL
.STACK 100h
.CODE
start:
    xor ax,ax
    mov bx,1
    mov cx,100
sum_loop:
    add ax,bx
    inc bx
    loop sum_loop
    call PrintDec           ; Convert the computed value, not a literal string.
    mov ax,4C00h
    int 21h
INCLUDE PRINTNUM.INC
END start
