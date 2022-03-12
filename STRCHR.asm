global  strchr
extern  strlen
;--------------------------------------------------
;STRCHR
;Entry:
;       bx -- symbol for searching
;       si -- addr of array
;Destr: cx, ax, di
;
;Output: cx - address of the first occurrence of the character in string
;--------------------------------------------------

strchr:

        push    rsi              ; Preparing for SCAS
        pop     rdi              ; now have actual si value

        call    strlen          ; now in cx we have amount of symbols

        mov     rax, rbx

        mov     rbx, rcx          ; actual length in bx
        
        inc     rcx              ; for searching last symb in string

        repne   scasb           ; searching symb
                                ; cx now have position from the end or 0
        
        test    rcx, rcx
        jz      .end

        sub     rbx, rcx
        mov     rcx, rbx
             
        jmp     .ret

.end:  
        dec     rcx

.ret:
        ret
        