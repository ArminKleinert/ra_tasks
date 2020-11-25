; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

; if(x < 10) {S();} 
; else if(x == 10) {T();} 
; else if(x > 10) {V();} 
; else {W();}

; Wir waren uns nicht sicher, ob mehrere Jumps nach einem cmp ok sind, 
; aber scheinbar schon:
; https://stackoverflow.com/questions/21580187/is-it-safe-to-do-two-consecutive-jumps-in-assembly
        cmp     x, 10 
        jb      .LCS         ; Go to the call to S
        je      .LCT         ; Go to the call to T
        ja      .LCV         ; Go to the call to T
        call    W            ; Call W
        jmp     .LEND        ; Go to end
.LCS:                        ; Call S
        call    S
        jmp     .LEND        ; Go to end
.LCT:                        ; Call T
        call    T
        jmp     .LEND        ; Go to end
.LCV:
        call    V            ; Call V
        jmp     .LEND        ; Go to end
.LEND:
        ; ...

; Alternative

        cmp     x, 10
        jl      .LCS         ; Go to the call to S
        cmp     x, 10
        je      .LCT         ; Go to the call to T
        ; No check for >10 is necessary
        ; Also no call to W since there is no "else" condition.
        call    V            ; Call V
        jmp     .LEND        ; Go to end
.LCS:                        ; Call S
        call    S
        jmp     .LEND        ; Go to end
.LCT:                        ; Call T
        call    T
.LEND:
        ; ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while(x != 10) {x = S();}
; Variante 1

        cmp x, 10
        je .LEND
.LSTART:
        call S
        mov x, rax
        cmp x, 10
        jne .LSTART
.LEND:
        ; ...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while(x != 10) {x = S();}
; Variante 2

.LSTART:
        cmp x, 10
        je .LEND
        call S
        mov x, rax
        jmp .LSTART
.LEND:
        ; ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Use loop instruction. rcx is the loop counter. 
; If it is 0 when the loop instruction is encountered, 
; the instruction will be ignored.

; while(x != 10) {x = S();}
; Variante 3

        cmp x, 10            ; Assuming x is in rdi
        je .LEND
.LSTART1:
        call S
        mov x, rax
        mov rcx, x           ; Move x to rcx
        sub rcx, 10          ; Sub 10 from rcx. If rcx was ==10, 
                             ; the loop below will not trigger.
        loop .LSTART1
.LEND1:
        ; ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dwt_start:       ; Jump label
        call S               ; rax = S()
        mov x, rax
        cmp x, 10          ; Compare to 10
        jne dwt_start      ; Restart loop if rax != 10

; Not using any x since there is no real use for it
dwt_start_alternative:       ; Jump label
        call S               ; rax = S()
        cmp rax, 10          ; Compare to 10
        jne dwt_start_alternative ; Restart loop if rax != 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for-loop

; Assuming that S handles 64-bit values
; i = rdi

        xor rdi, rdi
                             ; Using rdi as for-counter (init as 0)
        ; It is not necessary to check rdi here.
for_start:                   ; Jump label
        call S               ; rax = S(rdi)
        inc rdi
        cmp rdi, 10          ; Compare to 10
        jb for_start         ; Restart loop if rdi < 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values
; Unrolled for :)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; switch-case

; Assuming that S handles 64-bit values
; x is rax

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
        mul rdi
stcd:                        ; Default case
        mov rax, 100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Assuming that S handles 64-bit values
; x is rax

; Switch test optimized?

        call S                ; Still call S, assuming it changes
                              ; something like printing to the console
        mov rax, 100          ; Set output




