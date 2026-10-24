; 8086 / MASM 5.x. Rows 9..1, columns 1..row.
.MODEL SMALL
.STACK 100h
.DATA
banner DB 'The 9mul9 table:',0Dh,0Ah,'$'
.CODE
start:
    mov ax,@data
    mov ds,ax
    mov dx,OFFSET banner
    mov ah,09h
    int 21h
    mov bh,9
    mov cx,9
row_loop:
    push cx                 ; Save outer CX before starting the inner loop.
    xor cx,cx
    mov cl,bh
    mov bl,1
column_loop:
    call PrintCell          ; Uses the caller's BX/CX, then restores them.
    inc bl
    loop column_loop
    mov dl,0Dh
    call PutChar
    mov dl,0Ah
    call PutChar
    pop cx
    dec bh
    loop row_loop
    mov ax,4C00h
    int 21h
INCLUDE TABLEIO.INC
END start
