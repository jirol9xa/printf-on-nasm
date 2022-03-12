;-----------------------------------------------------
;   Strlen on asm
;   Entry:
;          Elem in stack or si - addr of begining of string
;   Return:
;          CX - length of string
;   Destr: ax, cx, si
;-----------------------------------------------------

strlen      proc
    
    xor     cx, cx
    xor     ax, ax

@@NextSymb:

        inc     cx

        lodsb             ; al now have next symb

        cmp     ax, '$'   ; comparing with end symb
        jne     @@NextSymb

        sub     cx, 1
        ret

endp
