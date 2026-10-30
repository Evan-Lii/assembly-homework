; 8086 / MASM 5.x. Check all 81 original bytes; do not alter them.
.MODEL SMALL
.STACK 100h
.DATA
table DB 7,2,3,4,5,6,7,8,9
      DB 2,4,7,8,10,12,14,16,18
      DB 3,6,9,12,15,18,21,24,27
      DB 4,8,12,16,7,24,28,32,36
      DB 5,10,15,20,25,30,35,40,45
      DB 6,12,18,24,30,7,42,48,54
      DB 7,14,21,28,35,42,49,56,63
      DB 8,16,24,32,40,48,56,7,72
      DB 9,18,27,36,45,54,63,72,81
heading DB 'x y',0Dh,0Ah,'$'
finished DB 0Dh,0Ah,'accomplish!',0Dh,0Ah,'$'
error_text DB ' error',0Dh,0Ah
error_len EQU $-error_text
.CODE
start:
    mov ax,@data
    mov ds,ax
    mov dx,OFFSET heading
    mov ah,09h
    int 21h
    mov si,OFFSET table      ; Row-major data: DS:[SI] visits each byte once.
    mov bh,1
    mov cx,9
row_loop:
    push cx                 ; Preserve outer counter before reusing CX.
    mov cx,9
    mov bl,1
column_loop:
    mov al,bh
    mul bl                  ; AL * BL -> AX, expected value 1..81.
    cmp al,[si]
    je entry_ok
    call PrintError         ; Preserves SI (table pointer) and inner CX.
entry_ok:
    inc si                  ; Advance even when the current entry is wrong.
    inc bl
    loop column_loop
    pop cx
    inc bh
    loop row_loop
    mov dx,OFFSET finished
    mov ah,09h
    int 21h
    mov ax,4C00h
    int 21h
INCLUDE CHECKIO.INC
END start
