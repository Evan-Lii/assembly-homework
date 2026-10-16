; 8086 / MASM 5.x / DOS: one or two hex digits -> decimal 0..255.
.MODEL SMALL
.STACK 100h
.DATA
prompt  DB 'Please input a Hex number:',0Dh,0Ah,'$'
result  DB 'The Dec number:',0Dh,0Ah,'$'
badmsg  DB 'Invalid input: enter 1 or 2 hex digits (0-9, A-F, a-f).',0Dh,0Ah,'$'
newline DB 0Dh,0Ah,'$'
; A larger buffer lets validation reject overlong input instead of truncating it to two digits.
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
    cmp cx,2
    ja invalid
    mov si,OFFSET input+2
    xor bx,bx
parse_hex:
    mov al,[si]
    inc si
    cmp al,'0'
    jb invalid
    cmp al,'9'
    jbe digit
    and al,0DFh             ; Map lowercase a-f to uppercase before checking.
    cmp al,'A'
    jb invalid
    cmp al,'F'
    ja invalid
    sub al,'A'-10
    jmp accumulate
digit:
    sub al,'0'
accumulate:
    xor ah,ah
    shl bx,1                ; Four single-bit shifts also work on an 8086.
    shl bx,1
    shl bx,1
    shl bx,1
    add bx,ax               ; value = value * 16 + digit.
    loop parse_hex
    jmp valid
invalid:
    mov dx,OFFSET badmsg
    mov ah,09h
    int 21h
    mov ax,4C01h
    int 21h
valid:
    mov dx,OFFSET result
    mov ah,09h
    int 21h
    mov ax,bx
    mov bx,10
    xor cx,cx
split_decimal:
    xor dx,dx               ; DIV uses the full DX:AX dividend.
    div bx
    push dx                 ; Remainders are generated from right to left.
    inc cx
    or ax,ax
    jnz split_decimal
print_decimal:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop print_decimal
    mov dx,OFFSET newline
    mov ah,09h
    int 21h
    mov ax,4C00h
    int 21h
END start
