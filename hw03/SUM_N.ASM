; Read n in 1..100 using INT 21h/AH=0Ah; print 1+...+n in decimal.
.MODEL SMALL
.STACK 100h
.DATA
prompt  DB 'Please input n (1-100):',0Dh,0Ah,'$'
result  DB 'The sum number:',0Dh,0Ah,'$'
badmsg  DB 'Invalid input: enter 1 to 3 digits, value 1-100.',0Dh,0Ah,'$'
newline DB 0Dh,0Ah,'$'
input   DB 80,0,81 DUP (0)
.CODE
start:
    mov ax,@data
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
    mov di,dx               ; MUL overwrites DX.
    mul bx
    add ax,di               ; At most 3 digits, so the value cannot exceed 999.
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
    mov cx,ax
    xor ax,ax
    mov bx,1
sum_loop:
    add ax,bx
    inc bx
    loop sum_loop
    push ax                 ; Protect the sum before changing AH for DOS output.
    mov dx,OFFSET result
    mov ah,09h
    int 21h
    pop ax
    call PrintDec
    mov ax,4C00h
    int 21h
INCLUDE PRINTNUM.INC
END start
