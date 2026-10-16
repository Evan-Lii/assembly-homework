; 8086 / MASM 5.x / DOS: decimal 0..65535 -> uppercase hexadecimal.
.MODEL SMALL
.STACK 100h
.DATA
prompt  DB 'Please input a Dec number (0-65535):',0Dh,0Ah,'$'
result  DB 'The Hex number:',0Dh,0Ah,'$'
badmsg  DB 'Invalid input: enter 1 to 5 decimal digits, value 0-65535.',0Dh,0Ah,'$'
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
    cmp cx,5
    ja invalid
    mov si,OFFSET input+2
    xor ax,ax
    mov bx,10
parse_decimal:
    mov dl,[si]
    inc si
    cmp dl,'0'
    jb invalid
    cmp dl,'9'
    ja invalid
    sub dl,'0'
    xor dh,dh
    mov di,dx               ; MUL overwrites DX, so preserve this digit in DI.
    mul bx
    or dx,dx                ; Reject overflow before keeping only AX.
    jnz invalid
    add ax,di               ; value = value * 10 + digit.
    jc invalid
    loop parse_decimal
    jmp valid
invalid:
    mov dx,OFFSET badmsg
    mov ah,09h
    int 21h
    mov ax,4C01h
    int 21h
valid:
    push ax                 ; AH is about to select DOS string output.
    mov dx,OFFSET result
    mov ah,09h
    int 21h
    pop ax
    mov bx,16
    xor cx,cx
split_hex:
    xor dx,dx
    div bx
    push dx
    inc cx
    or ax,ax
    jnz split_hex
print_hex:
    pop dx
    cmp dl,9
    jbe numeric_digit
    add dl,'A'-10
    jmp emit
numeric_digit:
    add dl,'0'
emit:
    mov ah,02h
    int 21h
    loop print_hex
    mov dx,OFFSET newline
    mov ah,09h
    int 21h
    mov ax,4C00h
    int 21h
END start
