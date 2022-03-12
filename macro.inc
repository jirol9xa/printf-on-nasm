;------------------------------------------------
; macro for putting one symb in buff and checking buff of overflowing
;       DI - current position in buff
;       AX - current symb
;
;------------------------------------------------
%macro  PUTCHAR 0

        test    ax, ax          ; checking for \0
        jz      end_printf

        cmp     rdi, buff_end   ; checking on full buff
        jb     %%buff_ok 

        call    printbuff

%%buff_ok:
        stosb


%endmacro