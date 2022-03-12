global  switch
extern  strchr
extern  end_printf
extern  printbuff
extern  itoa
%include        "macro.inc"

section .text
;------------------------------------------------
;Func for switching between %
;Entry:
;       AX - type of %
;       SI - addr in stack of arg
;       DI - addr of buff
;Destr:
;------------------------------------------------
%macro  GENINT  1
        mov     ax, [r13]       ; we have number in ax
        
        push    rbx             ; saving rbx before itoa
        push    rsi             ; and rsi

        mov     rbx, %1         ; radix

        call    itoa

        pop     rsi             ; restoring
        pop     rbx             ; restoring after itoa

        jmp     endcase

%endmacro
switch:

        ;I need make tables with instructions istead of calls                ;makecase        char, prntchr           ; if we have %c
        ;I need make tables with instructions istead of calls                ;makecase        string, prntstr         ; if we have %s
        ;I need make tables with instructions istead of calls                ;makecase        int, prntint            ; if we have %d
        ;I need make tables with instructions istead of calls                ;makecase        int2, prntint2          ; if we have %o
        ;I need make tables with instructions istead of calls                ;makecase        int8, prntint8          ; if we have %b
        ;I need make tables with instructions istead of calls                ;makecase        int16, prntint16        ; if we have %x 
        ;I need make tables with instructions istead of calls                ;makecase        percnt, prntpercnt      ; if we have %%

        ; now we need jump on case

        push    rsi     ; saving before switch

        ; preparing for strchr
        mov     rbx, rax
        push    rsi     ; saving before strchr
        push    rdi     ; saving before strchr
        mov     rsi, keys

        call    strchr  ; now in cx we have number of case

        pop     rdi     ; restoring rdi
        pop     rsi     ; restoring rsi

        jmp     [jump_table + rcx * 8]  ; jumping on case
        ; need make errors detection


char:                           ; if we have %c
        mov     al, [r13]       ; we have arg in al
        PUTCHAR endcase         ; copying ax in buff
        jmp     endcase

string:                         ; if we have %s

        mov     rsi, [r13]      ; we have string addr in rsi

.printing:
        lodsb                   ; now we have current symb in ax

        PUTCHAR endcase         ; put ax in buff
        jmp     .printing

        jmp     endcase

int:                            ; if we have %d
        GENINT  10
int2:                           ; if we have %b
        GENINT  2
int8:                           ; if we have %b
        GENINT  8
int16:                          ; if we have %x
        GENINT  16
percnt:
        stosb
        jmp     return
endcase:
        add     r13, 8  ; r13 now contain next arg

return:
        pop     rsi     ; restoring rsi

        ret


section .data
jump_table      dq      char, string, int, int2, int8, int16, percnt
keys    db      "csdbox%"