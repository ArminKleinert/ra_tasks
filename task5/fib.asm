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
          xor r9, r9
          mov r10, 1
          xor rax, rax
          
.fib_it_loop:
          cmp r8, 0
          je .fib_it_end
          mov r9, r10
          mov r10, rax
          add r9, r10
          mov rax, r9
          add r8, -1
          jmp .fib_it_loop

.fib_it_end:
          ret




; Recursive version of fibonnacci calculation.
; fib(0) = 0
; fib(1) = 1
; fib(n) = fib(n-1) + fib(n-2)
;
; rdi = n (uint64_t)
asm_fib_rek:
          ; n == 0 (cannot be <0 because n is unsigned)
          cmp rdi, 0
          je .fib_rek_zero

          ; n >= 3
          cmp rdi, 3
          jae .fib_rek_call

          ; n <  3 (and n > 0)
          mov rax, 1
          jmp .fib_rek_end

.fib_rek_call:
          push rdi ; Save n on stack
          dec rdi ; n -= 1
          call asm_fib_rek ; Call fib(n-1)

          pop rdi ; Pop n from stack
          sub rdi, 2 ; n -= 2
          push rax ; Push result of fib(n-1)
          call asm_fib_rek ; Call fib(n-2)
          pop rdi ; Pop result of fib(n-1)

          add rax, rdi ; add results of fib(n-1) and fib(n-2)
          jmp .fib_rek_end

.fib_rek_zero:
          mov rax, 0

.fib_rek_end:
          ret
























