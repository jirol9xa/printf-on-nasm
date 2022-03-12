global  switch
extern  strchr
extern  end_printf
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

switch:

        jump_table      dq      char, string, int, int2, int8, int16, percnt

        ;I need make tables with instructions istead of calls                ;makecase        char, prntchr           ; if we have %c
        ;I need make tables with instructions istead of calls                ;makecase        string, prntstr         ; if we have %s
        ;I need make tables with instructions istead of calls                ;makecase        int, prntint            ; if we have %d
        ;I need make tables with instructions istead of calls                ;makecase        int2, prntint2          ; if we have %o
        ;I need make tables with instructions istead of calls                ;makecase        int8, prntint8          ; if we have %b
        ;I need make tables with instructions istead of calls                ;makecase        int16, prntint16        ; if we have %x 
        ;I need make tables with instructions istead of calls                ;makecase        percnt, prntpercnt      ; if we have %%

        ; now we need jump on case

        ; preparing for strchr
        mov     rbx, rax
        push    rsi      ; saving before strchr

        call    strchr  ; now in cx we have number of case

        pop     rsi      ; restoring si

        jmp     [jump_table + rcx * 8]  ; jumping on case
        ; need make errors detection


char:                   ; if we have %c
        lodsb           ; now have symbol in ax
        PUTCHAR         ; copying ax in buff
        jmp     endcase

string:                 ; if we have %s
        push    si      ; saving before strlen

        lea     cx, [cnr - buff]        ; now we have free space in buff in cx
                                        ; if we could oveflow buff, we need print it and rewrite
        ; do it later

int:
int2:
int8:
int16:
percnt:

endcase:
        add     r13, 8  ; r13 now contain next arg

        ret


section .data
keys    db      "csdbox%"