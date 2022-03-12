global  itoa
extern  strlen
section .text
;------------------------------------------------
;ITOA
;Entry:
;       AX - number
;       DI - addr of res array
;       BX - radix
;Destr: AX, DX, DI
;Ret:
;------------------------------------------------

itoa: 

        push    rdi              ; addr of res arr in stack
                                ; for reverse

.Next:

        xor     rdx, rdx

        div     rbx              ; in dx the remainder of the division
                                ; in ax quotient of division

        push    rax              ; now quotient in stack
        mov     rax, rdx          ; preparing before hex2ascii

        call    hex2ascii       ; in ax now ascii of number

        mov     ah, 4eh

        stosb                   ; now we have last number at first place in 

        pop     rax              ; now quotient in ax

        test    rax, rax

        ja      .Next

        mov     rdx, 0           ; creating end-symb !!!!!!!!!! mb \0 doesn't fit
        mov     [rdi], rdx


        pop     rsi              ; addr of res arr in si
                                ; for strlen
        push    rsi

        call    strlen          ; length of string in cx now

        pop     rsi              ; si have head of array

        mov     rdx, rsi
        add     rdx, rcx
        dec     rdx              ; addr of last symb in dx 

        mov     rdi, rdx          ; di have tail of array


.Reverse:

        mov     al, [rsi]
        mov     bl, [rdi]

        mov     [rsi], bl
        mov     [rdi], al

        inc     rsi
        dec     rdi

        cmp     rsi, rdi
        jb      .Reverse

        ret


;------------------------------------------------
;------------------------------------------------
hex2ascii:
        ;cmp     al, 10
        ;sbb     al, 69h
        ;das

        push    rbx     ; saving rbx

        mov     rbx, symtable
        xlatb                   ; now in ax we have ascii-code of symbol
        ret



section .data
res     times 4 db '$'
symtable        db "0123456789ABCDEF"