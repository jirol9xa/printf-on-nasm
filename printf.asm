section .text
global  _start
global  end_printf
extern  strlen
extern  switch
extern  strchr
extern  strncpy
%include        "macro.inc"


_start:
        jmp     realstart


;------------------------------------------------
;printf for C language
;Entry: (all params must be pushed in stack)
;       format string, the only required parameter
;       mb args for %*
;       supported %c (char), %s (string), %d (integer), %b (int with radix 2), %o (int with radix 8),
;                 %x (int with radix 16), %% (print persent, does not require a parameter)
;Destr:
;       rsi, rdi, r8, r9, r13, rax, rbx, rcx, rdx
;------------------------------------------------
printf:
        push    rbp
        mov     rbp, rsp  ; stack frame prologue

        mov     rsi, [rbp + 8]  ; now we have rsi pointing on ouw format string
        mov     rdi, buff       ; now we have buff addr in rdi

        lea     r13, [rbp + 16] ; r13 contain current arg from stack

        ; now we need copying our format string in buff 
        ; with the correct replacement of %

        jmp     printing

make_swtch:
        lodsb   
        call    switch

printing:
        lodsb                   ; now we have current symb in ax

        cmp     ax, '%'
        je      make_swtch      ; if we have % we need make switch      

        PUTCHAR                 ; put ax in buff
        jmp     printing


end_printf:
        pop     rbp
        ret     


;------------------------------------------------
; printbuff calling, when prog is finishing or when buff is full
; after completion, the function assigns the RDI to the beginning of the buff
;Entry:
;Destr: RSI
;------------------------------------------------
printbuff:
        push    rax     ;
        push    rsi     ;
        push    rdx     ; saving before printing

        mov     rax, 0x01
        mov     rdi, 1
        mov     rsi, buff
        lea     rdx, [buff_end - buff]
        syscall                         ; printing buff in console

        mov     rdi, buff               ; now we have beggining of buff in rdi
        pop     rdx
        pop     rsi
        pop     rax

        ret


realstart:
        mov     rax, 0x3c       ; end of programm
        xor     rdi, rdi
        syscall


section         .bss
buff            resb    128 
buff_end        equ     $
