DIGITS EQU 21
; Little-endian decimal digits, sufficient for F(100)=354224848179261915075.
memo DB DIGITS DUP (0)       ; F(0)=0.
     DB 1,20 DUP (0)         ; F(1)=1.
     DB 2079 DUP (0)         ; 99 further entries, 21 bytes each.
ready DB 1,1,99 DUP (0)
min_sp DW 4096              ; Lowest SP observed inside Fib, after its prologue.
end_sp DW 0
