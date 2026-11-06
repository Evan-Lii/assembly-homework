; Cold n=100 recursion, then all 101 cached results; actual shared procedure.
STK SEGMENT PARA STACK 'STACK'
stack_guard DW 0A55Ah
DB 4094 DUP (0)
stack_top LABEL WORD
STK ENDS
DATA SEGMENT
INCLUDE FIBDATA.INC
current DW 100
passmsg DB 'PASS: 102 calls; registers, result pointer, SP, guard and min_SP.',0Dh,0Ah,'$'
failmsg DB 'FAIL',0Dh,0Ah,'$'
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STK
start:
    mov ax,STK
    mov ss,ax
    mov sp,OFFSET stack_top
    mov ax,DATA
    mov ds,ax
    call TestOne
    cmp min_sp,0A84h
    jne failed
    mov current,0
next_n:
    call TestOne
    inc current
    cmp current,101
    jb next_n
    mov dx,OFFSET passmsg
    mov ah,09h
    int 21h
    mov ax,4C00h
    int 21h
TestOne PROC NEAR
    mov ax,current
    mov bx,1234h
    mov cx,5678h
    mov dx,9ABCh
    mov di,0DEF0h
    mov bp,1357h
    call Fib
    cmp ax,current
    jne failed
    cmp bx,1234h
    jne failed
    cmp cx,5678h
    jne failed
    cmp dx,9ABCh
    jne failed
    cmp di,0DEF0h
    jne failed
    cmp bp,1357h
    jne failed
    cmp sp,0FFEh          ; TestOne's return address is still on the stack.
    jne failed
    cmp WORD PTR ss:[0],0A55Ah
    jne failed
    mov bx,DIGITS
    mul bx
    add ax,OFFSET memo
    cmp ax,si
    jne failed
    ret
TestOne ENDP
failed:
    mov dx,OFFSET failmsg
    mov ah,09h
    int 21h
    mov ax,4C01h
    int 21h
INCLUDE FIBPROC.INC
CODE ENDS
END start
