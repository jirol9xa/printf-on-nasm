;------------------------------------------------
;Func for switching between %
;Entry:
;       AX - type of %
;       SI - addr in stack of arg
;       DI - addr of buff
;Destr:
;------------------------------------------------
%macro  makecase 2

%1:     jmp     %2
        ;jmp     endcase

%endmacro
print   proc    near

        jump_table      dw      char, string, int, int2, int8, int16, percnt

        makecase        char, prntchr           ; if we have %c
        makecase        string, prntstr         ; if we have %s
        makecase        int, prntint            ; if we have %d
        makecase        int2, prntint2          ; if we have %o
        makecase        int8, prntint8          ; if we have %b
        makecase        int16, prntint16        ; if we have %x 
        makecase        percnt, prntpercnt      ; if we have %%

char:  
        


endcase:

print   endp