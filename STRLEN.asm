global  strlen
section .text
;-----------------------------------------------------
;   Strlen on asm
;   Entry:
;          Elem in stack or si - addr of begining of string
;   Return:
;          CX - length of string
;   Destr: ax, cx, si
;-----------------------------------------------------

strlen:
    
        xor     cx, cx
        xor     ax, ax

.NextSymb:

        inc     cx

        lodsb             ; al now have next symb

        ;cmp     ax, '$'   ; comparing with end symb
        test    ax, ax
        jne     .NextSymb

        sub     cx, 1

        ret
