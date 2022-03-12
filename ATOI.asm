.model tiny
.code
org 100h
LOCALS @@


;------------------------------------------------
;Atoi
;Entry:
;       SI - addr of string
;       DX - radix
;Ret:
;       CX - number
;Destr:
;       SI, CX, BX, DX
;------------------------------------------------



start:
        jmp     realstart


        include STRLEN.ASM


atoi    proc
        ;bounds:
        ;lower_bound     db      0
        ;upper_bound     db      ?

        ;push    dx
        ;pop     upper_bound    ; now we can use bound operation

        mov     bx, offset array
        mov     di, bx                  ; saving number addr for scas
        
        mov     bx, 16d         ; bx have numbers amount

        push    si              ; saving si before strlen

        call    strlen          ; cx now have string length

        pop     si

        push    di              ; saving di for next step

        xor     ax, ax
                                ; now preparing ended

        push    cx              ; symb amount in stack

        mov     cx, 17d

        lodsb                   ; current symb now in al

        repne   scasb           ; searching symb
                                ; cx now have position from the end or FFFF
        
        test    cx, cx
        jz      @@end1

        sub     bx, cx
        mov     cx, bx

        mov     bx, 16d             ; actual array length in bx

        jmp     @@end2

        @@end1:  
        dec     cx

        @@end2:

        mov     ax, cx           ; ax have position of symb in our array of numbers
        
        pop     cx               ; now symb amount in cx
        pop     di               ; addr of array in di 

        ;lodsb                   ; symbol if al
        ;xlatb                   ; ascii of symb in al

        cmp     ax, 0
        jb      @@end
        cmp     ax, dx
        jae     @@end

        ;bound   ax, bounds             

        mov     result, ax              ; cx have sum if degree (n - 1)
                                        ; n current amount of passed symbols

        dec     cx

@@Next: 
        push    di                      ; addr of array in stack
        push    cx                      ; symb amount in stack


        lodsb                   ; current symb in al

        mov     cx, 17d         ; now cx have length of array with numbers

        repne   scasb           ; searching symb
                                ; cx now have position from the end or 0
        
        test    cx, cx
        jz      @@end3

        sub     bx, cx
        mov     cx, bx
             
        mov     bx, 16d

        jmp     @@end4

        @@end3:  
        dec     cx

        @@end4:

        mov     ax, cx                  ; ax have position of symb in our array of numbers
        
        pop     cx                      ; now symb amount in cx
        pop     di                      ; addr of array in di 

        ;lodsb                          ; symbol if al
        ;xlatb                          ; ascii of symb in al

        cmp     ax, 0
        jb      @@end
        cmp     ax, dx
        jae     @@end

        ;bound   ax, bounds

        xchg    result, ax              ; preparing for mul                
        mul     dl                      ; ax have current sum now
        xchg    result, ax 

        add     result, ax              ; cx have sum if degree (n - 1)
                                        ; n current amount of passed symbols

        loop    @@Next

@@end:
        mov     cx, result
        ret

endp

;------------------------------------------------
;Hex2ascii
;Entry:
;       AX - sybm
;Ret:
;       AX - ascii of symb
;------------------------------------------------

hex2ascii       proc
        cmp     al, 10
        sbb     al, 69h
        das

        ret
endp


realstart:

        mov     dx, offset number
        mov     si, dx
        mov     dx, 8d

        call    atoi

        mov     dx, 0b800h
        mov     es, dx

        xor     di, di

        cmp     cx, 08h
        je      right

        mov     ah, 4eh
        mov     al, '!'
        mov     es:[di], ax
        jmp     ending


right:
        mov     ah, 4eh
        mov     al, '@'
        mov     es:[di], ax

ending:
        mov     ax, 4c00h
        int     21h


.data

array   db      '0123456789ABCDEF'
result  dw      -1
number  db      '10$'

end     start