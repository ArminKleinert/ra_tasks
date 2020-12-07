; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert

; Reihenfolge Register: rdi, rsi, rdx, rcx, r8, r9

; calc_add(float f0, float f1)
; xmm0 = f0
; xmm1 = f1


; r8 = f0 mantissa
; r9 = f0 exponent (no sign)
; r10 = f0 sign
; 
; r11 = f1 mantissa
; r12 = f1 exponent (no sign)
; r13 = f1 sign (rsi)
; 
; r15 = temporary

          global calc_add
calc_add:
          ; Prepare registers for later
          xor r8, r8
          xor r9, r9
          xor r10, r10
          
          xor r11, r11
          xor r12, r12
          xor r13, r13
          
          xor rax, rax

          ; r8 = (f0 & 0x7FFFFF) | 0x80000
          movd r8d, xmm0
          and r8d, 0x7FFFFF	
          or r8d, 0x800000

          ; r9 = (f0 >> 23) & 0xFF // Exponent
          movd r9d, xmm0
          shr r9d, 23
          and r9d, 0xFF

          ; r10 = f0 >> 31 // Sign
          movd r10d, xmm0
          shr r10d, 31

          ; r11 = (f1 & 0x7FFFFF) | 0x800000
          movd r11d, xmm1
          and r11d, 0x7FFFFF
          or r11d, 0x800000

          ; r12 = (f1 >> 23) & 0xFF
          movd r12d, xmm1
          shr r12d, 23
          and r12d, 0xFF

          ; r13 = f1 >> 31 // Sign
          movd r13d, xmm1
          shr r13d, 31

          
          ; Set r15 = 0 for use as temporary below
          mov r15, 0

          ; Choose whether to adjust exp of f0 or f1
          cmp r9b, r12b
          ja .ca_need_adjust_f0

          ; Adjust exponent of f0 to fit f1
          mov r15, r12
          sub r15, r9 ; Difference of exponents here.
          mov r9, r12

.ca_adj_f1_loop:
          cmp r15, 0
          je .ca_adjustment_done
          shr r8, 1
          sub r15, 1
          jmp .ca_adj_f1_loop

.ca_need_adjust_f0:
          mov r15, r9
          sub r15, r12	; Difference of exponents here.
          mov r12, r9

.ca_adj_f0_loop:
          cmp r15, 0
          je .ca_adjustment_done
          shr r11, 1
          sub r15, 1
          jmp .ca_adj_f0_loop

.ca_adjustment_done:
          cmp r10, r13	; Compare signs
          je .ca_same_sign
          
          cmp r8, r11	; Compare mantissas (the signs are not equal!)
          ja .ca_mantissa_1_gr
          
          sub r11, r8	; Sum mantissas in r11 
          mov rax, r13	; rax = sign
          jmp .ca_normalise

.ca_mantissa_1_gr:
          sub r8, r11
          mov r11, r8	; Sum mantissas in r11
          mov rax, r10	; rax = sign
          jmp .ca_normalise

.ca_same_sign:
          add r11, r8	; Sum mantissas in r11
          mov rax, r13	; rax = sign

.ca_normalise:
          shl r11, 7
          add r9, 1

.ca_normalise_loop:
          shl r11d, 1
          jc .ca_end
          sub r9, 1
          jmp .ca_normalise_loop

.ca_end:
          mov r13, 0
          or  r13d, r11d
          mov r11, r13
          shr r11, 9

          shl rax, 8
          or rax, r9
          shl rax, 23
          or rax, r11

          movd xmm0, eax
          ret


