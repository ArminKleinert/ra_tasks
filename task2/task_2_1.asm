
        global bla           ; For testing
bla:    cmp     rdi, 10      ; Assuming x is in rdi
        jl      .LCS         ; Go to the call to S
        cmp     rdi, 10
        je      .LCT         ; Go to the call to T
        ; No check for >10 is necessary
        ; Also no call to W sind there is no "else" condition.
        call    V            ; Call V
        jmp     .LEND        ; Go to end
.LCS:                        ; Call S
        call    S
        jmp     .LEND        ; Go to end
.LCT:                        ; Call T
        call    T
.LEND:
        mov     rdx, 0       ; I made the function return 0
        ret                  ; Return something for testing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        global while_test    ; For testing.
while_test:
        cmp rdi, 10          ; Assuming x is in rdi
        je .LEND
.LSTART:
        call S
        mov rdi, rax
        cmp rdi, 10
        jne .LSTART
.LEND:
        mov rax, rdi
        ret                  ; Return something for testing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        global while_test_2  ; For testing.
while_test:
        cmp rdi, 10          ; Assuming x is in rdi
        je .LEND
.LSTART1:
        call S
        mov rdi, rax
        mov rcx, rdi         ; Move x to rcx
        sub rcx, 10          ; Sub 10 from rcx. If rcx was ==10, 
                             ; the loop below will not trigger.
        loop .LSTART1
        mov rax, rdi
        ret                  ; Return something for testing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values

        global do_while_test ; For testing
do_while_test:
dwt_start:                   ; Jump label
        call S               ; rax = S()
        cmp rax, 10          ; Compare to 10
        jne dwt_start        ; Restart loop if rax != 10
        ret                  ; Return something for testing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values

        global for_test      ; For testing
for_test:
        xor rbx, rbx         ; Using rbx as for-counter (init as 0)
        ; It is not necessary to check rbx here.
for_start:                   ; Jump label
        mov rdi, rbx         ; Set rdi to current iteration (ebx)
        call S               ; rax = S(rdi)
        inc rbx
        cmp rbx, 10          ; Compare to 10
        jne for_start        ; Restart loop if rax != 10
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values
; Unrolled for

        global for_test_2    ; For testing
for_test_2:
        ; Iteration 0
        xor rdi, rdi         ; Set rdi to 0
        call S               ; rax = S(rdi)
        ; Iteration 1
        mov rdi, 1
        call S
        ; Iteration 2
        mov rdi, 2
        call S
        ; Iteration 3
        mov rdi, 3
        call S
        ; Iteration 4
        mov rdi, 4
        call S
        ; Iteration 5
        mov rdi, 5
        call S
        ; Iteration 6
        mov rdi, 6
        call S
        ; Iteration 7
        mov rdi, 7
        call S
        ; Iteration 8
        mov rdi, 8
        call S
        ; Iteration 9
        mov rdi, 9
        call S
        ; End
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values

        global switch_test   ; For testing
switch_test:
        call S
        cmp rax, 1
        je stc1              ; To case 1
        cmp rax, 2
        je stc2              ; To case 2
        cmp rax, 10
        je stc10             ; To case 10
        jmp stcd             ; To default case
stc1:                        ; Case 1
        add rax, 100
stc2:                        ; Case 2
        sub rax, 20
stc10:                       ; Case 10
        mov rdi, 10
        mul
stcd:                        ; Default case
        mov rax, 100
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values

; Switch test optimized?

        global switch_opt_test   ; For testing
switch_test:
        call S                ; Still call S, assuming it changes something like printing to the console
        mov rax, 100         ; Set output
        ret




