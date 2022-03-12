;------------------------------------------------
; macro for putting one symb in buff and checking buff of overflowing
;       DI - current position in buff
;       AX - current symb
;
;------------------------------------------------
%macro  PUTCHAR 1

        test    ax, ax          ; checking for \0
        jz      %1

        cmp     rdi, r10  ; checking on full buff
        jb     %%buff_ok 

        call    printbuff

%%buff_ok:
        stosb


%endmacro