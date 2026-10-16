; MASM 5.x / 8086 / DOS: print helloworld followed by CR/LF.
.MODEL SMALL
.STACK 100h
.DATA
message DB 'helloworld', 0Dh, 0Ah, '$'
.CODE
start:
    mov ax, @data           ; Obtain the program's data segment.
    mov ds, ax              ; DOS output uses the DS:DX string address.
    mov dx, OFFSET message
    mov ah, 09h             ; Print until '$'; the terminator is not printed.
    int 21h
    mov ax, 4C00h           ; Exit with status 0.
    int 21h
END start
