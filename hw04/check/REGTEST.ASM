; Exercise the exact same PrintError and PutChar as CHECK.ASM.
.MODEL SMALL
.STACK 100h
.DATA
error_text DB ' error',0Dh,0Ah
error_len EQU $-error_text
expect_bx DW 0101h
expect_sp DW 0
.CODE
start:
    mov ax,@data
    mov ds,ax
    mov expect_sp,sp
    mov ax,1234h
    mov bx,0101h
    mov cx,3456h
    mov dx,5678h
    mov si,6789h
    mov di,789Ah
    mov bp,89ABh
    call PrintError
    call CheckState
    mov bx,0507h
    mov expect_bx,bx
    call PrintError
    call CheckState
    mov bx,0909h
    mov expect_bx,bx
    call PrintError
    call CheckState
    mov ax,4C00h
    int 21h
CheckState PROC NEAR
    cmp ax,1234h
    jne failed
    cmp bx,expect_bx
    jne failed
    cmp cx,3456h
    jne failed
    cmp dx,5678h
    jne failed
    cmp si,6789h
    jne failed
    cmp di,789Ah
    jne failed
    cmp bp,89ABh
    jne failed
    push ax
    mov ax,sp
    add ax,4                ; Account for near CALL and this PUSH AX.
    cmp ax,expect_sp
    pop ax
    jne failed
    ret
failed:
    mov ax,4C01h
    int 21h
CheckState ENDP
INCLUDE CHECKIO.INC
END start
