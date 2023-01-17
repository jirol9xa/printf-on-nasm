section .text
global  _start
global  end_printf
global  printbuff
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

        mov     rsi, [rbp + 16]          ; now we have rsi pointing on ouw format string
        mov     rdi, buff               ; now we have buff addr in rdi
        mov     r8,  rdi                ; now we have beggining of buff in r8
        lea     r9,  [buff_end - buff]    ; and bufflen in r9
        mov     r10, buff_end           ; and buff_end in r10

        lea     r13, [rbp + 24] ; r13 contain current arg from stack

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

        PUTCHAR end_printf      ; put ax in buff
        jmp     printing


end_printf:
        cmp     rdi, r8
        je     .finish
        call    printbuff

.finish:
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
        push    r10
        
        mov     r10, rdi
        sub     r10, r8
        mov     r9, r10

        mov     rax, 0x01
        mov     rdi, 1
        mov     rsi, r8         ; r8 have buff start
        mov     rdx, r9         ; r9 have buff_len
        syscall                 ; printing buff in console

        mov     rdi, buff               ; now we have beggining of buff in rdi
        
        pop     r10
        pop     rdx
        pop     rsi
        pop     rax

        ret


realstart:
        push    255
        push    33
        push    100
        push    0x3802
        push    string
        push    '!'
        push    8
        push    0x3802
        push    format

        call    printf

        mov     rax, 0x3c       ; end of programm
        xor     rdi, rdi
        syscall

section         .data
format  db      "I love %x na %b%%%c I %s %x %d%%%c%b", 0x0A, 0
string  db      "love", 0
string2 db      "eda", 0

section         .bss
buff            resb    128
buff_end        equ     $
