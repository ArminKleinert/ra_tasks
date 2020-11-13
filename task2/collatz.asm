; rcx = k
; rdi = n

        global collatz
collatz:  
        xor rcx, rcx

coz_loop_start:
        cmp rdi, 1
        jg coz_loop_end

        ; Check if rdi is even using rbx as intermediate register
        mov rbx, rdi
        and rbx, 1           ; Discard all but lowest bit; If the LSB is 1, the number is odd
        jnz coz_if_mid

        ; rdi /= 2
        mov rax, rdi
        mov rdi, 2
        div rdi
        mov rdi, rax
coz_if_mid:
        ; rdi *= 3
        mov rax, rdi
        mov rdi, 3
        mul rdi
        mov rdi, rax
        
        inc rdi              ; rdi++

coz_if_end:
        inc rcx              ; rcx ++

coz_loop_end:
        mov rax, rcx
        ret




