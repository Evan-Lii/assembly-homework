; Print a-z, 13 letters per line. MASM 5.x / 8086 / DOS.
.MODEL SMALL
.STACK 100h
.CODE
start:
    mov bl, 'a'             ; BL keeps the next letter.
    mov cx, 2               ; Outer loop: two rows.
row_loop:
    push cx                 ; Save the outer counter before reusing CX.
    mov cx, 13              ; Inner loop: thirteen letters.
char_loop:
    mov dl, bl
    mov ah, 02h             ; DOS character output: DL is the character.
    int 21h
    inc bl
    cmp cx, 1
    je no_space             ; No trailing space after the last letter.
    mov dl, ' '
    mov ah, 02h
    int 21h
no_space:
    loop char_loop          ; CX = CX - 1; repeat while CX != 0.
    mov dl, 0Dh             ; DOS newline: carriage return, then line feed.
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    int 21h
    pop cx                  ; Restore the outer counter.
    loop row_loop
    mov ax, 4C00h           ; Return to DOS with exit status 0.
    int 21h
END start
