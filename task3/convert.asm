; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

; Reihenfolge Register: rdi, rsi, rdx, rcx, r8, r9

; pos(n,m)
; rdi = n
; rsi = m
pow1:
          mov rax, 1
.pow_loop:
          cmp rsi, 0
          jbe .pow_end
          mul rdi
          dec rsi
          jmp .pow_loop
.pow_end:
          ret

; Find string length
; rdi = str
slength:  
          xor rax, rax ; Write length here
.sl_loop:
          cmp byte [rdi], 0 ; while (*s)
          jbe .sl_end
          inc rax ; Increment counter
          inc rdi ; Increment pointer
          jmp .sl_loop
.sl_end:
          ret

; String to int64
; rdi = str
; rsi = base
;
; r8 = str
; r9 = base
; r10 = sign
; r11 = c (current char)
; r12 = result
; r13 = remaining length in string
; r14 = base multiplier (base_mul)
          global strToInt
strToInt: 
          ; Check if base is valid (>1 and <= 36).
          ; If not, jump to error.
          cmp rsi, 1
          jle .sti_error
          cmp rsi, 36
          jg .sti_error
          
          ; Copy str and base
          mov r8, rdi
          mov r9, rsi
          
          mov r10, 0 ; Sign 
          
          cmp byte [r8], 43 ; Check for '+'
          je .sti_signed
          
          cmp byte [r8], 45 ; Check for '-'
          jne .sti_setup ; If not, There is no sign
          
          mov r10, 1 ; Set sign
          
.sti_signed:
          inc r8 ; str++

.sti_setup:
          xor r12, r12 ; res = 0
          
          mov rdi, r8
          call slength
          mov r13, rax ; remaining_length = slength(str)
          mov r15, rax
          mov r14, r13 ; base_mul = remaining_length
          dec r14      ; base_mul --

.sti_loop:
          cmp r13, 0   ; Check if whole string was iterated
          jbe .sti_after_loop
          
          push rcx ; Save rcx to use it for reading c from string
          xor rcx, rcx
          xor r11, r11
          mov cl, byte [r8] ; c = *str
          mov r11, rcx
          pop rcx
          
          ; If c is a lower case letter, make it upper case.
          ; if (c >= 97 && c <= 122) c-=32
          cmp r11, 97
          jb .sti_upcase_check
          cmp r11, 122
          ja .sti_upcase_check
          sub r11, 32
          
.sti_upcase_check:
          ; If c is upper case letter, subtract 7
          ; So if c was 'A' for example, it will now be '9'+1.
          cmp r11, 65
          jb .sti_num_check
          cmp r11, 90
          ja .sti_num_check
          sub r11, 7

.sti_num_check:
          ; If c is below 48 ('0'), it is invalid
          
          cmp r11, 48
          jb .sti_error
          
          ; c -= 48
          ; Now the whole 36 symbols (0-9 and A-Z) follow each other,
          ; going from 0 to 35.
          ; So if c was '0' previously, it is 0 now.
          ; If it was 'F' before, it is 15 now.
          sub r11, 48
          
          ; If c is invalid for the given base, it is invalid
          cmp r11, r9
          jae .sti_error

          ; Get pow(base, base_mul)
          mov rdi, r9  ; rdi = base
          mov rsi, r14 ; rsi = base_mul
          call pow1    ; rax = base ** base_mul
          
          ; Multiply c by rax
          xor rdx, rdx
          mul r11      ; rax *= c
          xor rdx, rdx ; rdx should always be empty, but just to make sure...
          
          ; Add to result
          add r12, rax
          
          ; Prepare next iteration
          dec r14      ; base_mul --
          dec r13      ; remaining_length --
          inc r8       ; str ++
          
          ; Jump to beginning of loop
          jmp .sti_loop

.sti_after_loop:
          mov rax, r12

          ; If the sign was '-', negate result
          cmp r10, 1
          jne .sti_end
          neg rax      ; Set sign in rax (r10 is always 1 or -1)

.sti_end:
          ret
          
.sti_error:
          ; Return 0
          mov rax, 0
          ret

          global intToStr
intToStr: 
          mov rax, 0
          ret

