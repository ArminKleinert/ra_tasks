; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

; rax = n
; rbx = k

        global collatz
collatz:  
        mov rax, rdi ; move n into rax
        xor rbx, rbx ; k = 0

coz_loop_start:
        ; end if n <= 1
        cmp rax, 1
        jle coz_loop_end

        ; if start

        ; is_even(n)
        mov rcx, rax
        and rcx, 1
        jnz coz_if_else ; Not even -> Jump to else

        ; n /= 2
        mov rcx, 2
        xor rdx, rdx
        div rcx
        
        ; Alternative for n/=2 is
        ;shr rax, 1

        jmp coz_if_end
coz_if_else:
        ; n *= 3
        xor rdx, rdx
        mov rcx, 3
        mul rcx

        ; n++
        inc rax

coz_if_end:
        ; k++
        inc rbx

        jmp coz_loop_start
        
coz_loop_end:
        mov rax, rbx ; Move k to output
        ret          ; Profit?




