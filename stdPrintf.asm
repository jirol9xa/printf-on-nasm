global  main
extern  printf
extern  exit

section .text

main:
        mov     rdi, msg
        mov     rsi, [symb]
        xor     rax, rax        ; preparing for calling

        call    printf

        xor     rax, rax

        ;mov     rax, 0x3c       ; end of programm
        ;xor     rdi, rdi
        ;syscall

        ret

section .data
msg     db      'Standart printf sucks %d', 0xA, 0
symb    dd      228
