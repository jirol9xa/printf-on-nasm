section         .text
global          _start

_start:
        jmp     realstart

printf  proc    near
        push    bp

        pop     bp
        ret     
printf  endp


realstart:
        mov     rax, 0x3c       ; end of programm
        xor     rdi, rdi
        syscall

section         .data
buff    db      128 dup(0)