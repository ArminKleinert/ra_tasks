; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert

global asm_fib_it
global asm_fib_rek

; Reihenfolge Register: rdi, rsi, rdx, rcx, r8, r9
; rdi/r8: n (uint64_t)
; r9:     x (uint64_t)
; r10:    y (uint64_t)
; rax:    k (uint64_t)
asm_fib_it:
          mov r8, rdi
          xor r9, r9 ; x = 0
          mov r10, 1 ; y = 1
          xor rax, rax ; k = 0
          
.fib_it_loop:
          cmp r8, 0 ; n > 0
          je .fib_it_end
          mov r9, r10 ; x = y
          mov r10, rax ; y = k
          add r9, r10 ; x + y
          mov rax, r9 ; k = x + y
          add r8, -1 ; n--
          jmp .fib_it_loop

.fib_it_end:
          ret ; return k




; Recursive version of fibonnacci calculation.
; fib(0) = 0
; fib(1) = 1
; fib(n) = fib(n-1) + fib(n-2)
;
; rdi = n (uint64_t)
asm_fib_rek:
          ; n >= 2
          cmp rdi, 2
          jae .fib_rek_call
          
          ; n <  2
          mov rax, rdi
          jmp .fib_rek_end

.fib_rek_call:
          dec rdi ; n -= 1
          push rdi ; Save n on stack
          call asm_fib_rek ; Call fib(n-1)
          
          pop rdi ; Pop n from stack
          dec rdi ; n -= 1
          push rax ; Push result of fib(n-1)
          call asm_fib_rek ; Call fib(n-2) => Result in rax
          pop rdi ; Pop result of fib(n-1)

          add rax, rdi ; add results of fib(n-1) and fib(n-2)

.fib_rek_end:
          ret
























