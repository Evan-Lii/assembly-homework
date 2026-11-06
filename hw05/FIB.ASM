; 8086 / MASM 5.x. Exact F(n), 1<=n<=100, genuine memoized recursion.
STK SEGMENT PARA STACK 'STACK'
stack_guard DW 0A55Ah
            DB 4094 DUP (0)
stack_top LABEL WORD
STK ENDS
DATA SEGMENT
INCLUDE FIBDATA.INC
prompt DB 'Please input n (1-100):',0Dh,0Ah,'$'
result DB 'The Fibonacci number:',0Dh,0Ah,'$'
badmsg DB 'Invalid input: enter 1 to 3 digits, value 1-100.',0Dh,0Ah,'$'
stackmsg DB 'Stack check failed.',0Dh,0Ah,'$'
newline DB 0Dh,0Ah,'$'
input DB 80,0,81 DUP (0)
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STK
start:
    mov ax,STK
    mov ss,ax
    mov sp,OFFSET stack_top  ; Immediately after MOV SS; explicitly init SS:SP.
    mov ax,DATA
    mov ds,ax
    mov dx,OFFSET prompt
    mov ah,09h
    int 21h
    mov dx,OFFSET input
    mov ah,0Ah
    int 21h
    mov dx,OFFSET newline
    mov ah,09h
    int 21h
    xor cx,cx
    mov cl,input+1
    jcxz invalid
    cmp cx,3
    ja invalid
    mov si,OFFSET input+2
    xor ax,ax
    mov bx,10
parse_n:
    xor dx,dx
    mov dl,[si]
    inc si
    cmp dl,'0'
    jb invalid
    cmp dl,'9'
    ja invalid
    sub dl,'0'
    mov di,dx
    mul bx
    add ax,di
    loop parse_n
    cmp ax,1
    jb invalid
    cmp ax,100
    ja invalid
    jmp valid
invalid:
    mov dx,OFFSET badmsg
    mov ah,09h
    int 21h
    mov ax,4C01h
    int 21h
valid:
    call Fib                ; Input AX=n, output SI=&memo[n][0].
after_fib:
    mov end_sp,sp
    cmp sp,OFFSET stack_top
    jne stack_failed
    cmp WORD PTR ss:[0],0A55Ah
    jne stack_failed
    mov dx,OFFSET result
    mov ah,09h
    int 21h
    call PrintBig
    mov dx,OFFSET newline
    mov ah,09h
    int 21h
    mov ax,4C00h
    int 21h
stack_failed:
    mov dx,OFFSET stackmsg
    mov ah,09h
    int 21h
    mov ax,4C02h
    int 21h
INCLUDE FIBPROC.INC
INCLUDE FIBIO.INC
CODE ENDS
END start
