global  main
extern  printf
extern  exit

section .text

main:
        push    rdi
        push    rsi
        push    rdx
        push    rcx
        push    r8
        push    r9

        mov     rdi, msg
        mov     rsi, [d1]
        mov     rdx, d2
        mov     rcx, [d3]
        mov     r8,  [d4]
        mov     r9,  [d5]
        xor     rax, rax        ; preparing for calling

        call    printf

        pop     r9
        pop     r8
        pop     rcx
        pop     rdx
        pop     rsi
        pop     rdi

        xor     rax, rax

        ;mov     rax, 0x3c       ; end of programm
        ;xor     rdi, rdi
        ;syscall

        ret

section .data
msg     db      "BEBEBe",0xA, "%d %s %x %d%%%c", 0xA, 0
d1      dd         -1
d2      dd         "love"
d3      dd         3802
d4      dd         100
d5      dd         33
