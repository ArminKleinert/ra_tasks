; rcx = k
; rdi = n

        global collatz
collatz:  
        xor rcx, rcx

coz_loop_start:
        cmp rdi, 1
        jl coz_loop_end

        ; Check if rdi is even using rbx as intermediate register
        mov rbx, rdi
        and rbx, 1           ; Discard all but lowest bit; If the LSB is 1, the number is odd
        jnz coz_if_mid

        ; rdi /= 2
        ;mov rax, rdi
        ;mov rbx, 2
        ;xor rdi, rdi
        ;div rbx
        ;mov rdi, rax
        
        shr rdi, 1
        jmp coz_if_end
coz_if_mid:
        ; rdi *= 3
        mov rax, rdi
        mov rdi, 3
        mul rdi
        mov rdi, rax
        
        inc rdi              ; rdi++

coz_if_end:
        inc rcx              ; rcx ++

        jmp coz_loop_start
        
coz_loop_end:
        mov rax, rcx
        ret




