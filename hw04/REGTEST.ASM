; Check the actual output procedures and their register/stack preservation.
.MODEL SMALL
.STACK 100h
.DATA
expect_ax DW 1234h
expect_bx DW 0901h
expect_dx DW 5678h
expect_sp DW 0
.CODE
start:
    mov ax,@data
    mov ds,ax
    mov expect_sp,sp
    mov ax,1234h
    mov bx,0901h
    mov cx,3456h
    mov dx,5678h
    mov si,6789h
    mov di,789Ah
    mov bp,89ABh
    call PrintCell
    call CheckState
    mov bl,2
    mov expect_bx,bx
    call PrintCell
    call CheckState
    mov bl,9
    mov expect_bx,bx
    call PrintCell
    call CheckState
    mov ax,0
    mov expect_ax,ax
    call PrintDec
    call CheckState
    mov ax,9
    mov expect_ax,ax
    call PrintDec
    call CheckState
    mov ax,10
    mov expect_ax,ax
    call PrintDec
    call CheckState
    mov ax,81
    mov expect_ax,ax
    call PrintDec
    call CheckState
    mov ax,65535
    mov expect_ax,ax
    call PrintDec
    call CheckState
    mov dl,'!'
    mov expect_dx,dx
    call PutChar
    call CheckState
    mov ax,4C00h
    int 21h

CheckState PROC NEAR
    cmp ax,expect_ax
    jne check_failed
    cmp bx,expect_bx
    jne check_failed
    cmp cx,3456h
    jne check_failed
    cmp dx,expect_dx
    jne check_failed
    cmp si,6789h
    jne check_failed
    cmp di,789Ah
    jne check_failed
    cmp bp,89ABh
    jne check_failed
    push ax
    mov ax,sp
    add ax,4                ; Account for this call's return address and PUSH AX.
    cmp ax,expect_sp
    pop ax                  ; POP preserves the CMP flags.
    jne check_failed
    ret
check_failed:
    mov ax,4C01h
    int 21h
CheckState ENDP
INCLUDE TABLEIO.INC
END start
