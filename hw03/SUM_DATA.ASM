; Accumulate the result in a 16-bit variable in the data segment.
.MODEL SMALL
.STACK 100h
.DATA
sum_value DW 0              ; 5050 does not fit in an 8-bit DB variable.
.CODE
start:
    mov ax,@data
    mov ds,ax
    mov bx,1
    mov cx,100
sum_loop:
    add sum_value,bx
    inc bx
    loop sum_loop
    mov ax,sum_value
    call PrintDec
    mov ax,4C00h
    int 21h
INCLUDE PRINTNUM.INC
END start
