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

; Reihenfolge Register: rdi, rsi, rdx, rcx, r8, r9

; int64_t to string
; size_t intToStr(int64_t num, uint8_t base, char* str, size_t buf_len)
;
; rdi = num (int64_t)
; rsi = base (uint8_t)
; rdx = str (char*)
; rcx = buf_len (size_t)
;
; r8 = original string
; r9 = base
; r10 = buffer (pointer to original str but will be incremented)
; r11 = sign
; r12 = bytes_written (size_t; result)
; r13 = num (int64_t)
; r14 = buf_len (size_t)
; r15 = temporary values
          global intToStr 
intToStr:
          ; Check if base is valid (>1 and <= 36).
          ; If not, jump to error.
          cmp rsi, 1  ; Base too low
          jbe .its_error
          cmp rsi, 36 ; Base too high
          ja .its_error
          cmp rcx, 2  ; Not enough space in buffer
          jb .its_error
          cmp rdi, 0  ; Buffer points to null
          je .its_error
          
          jmp .its_setup
          
.its_error: ; Early error
          xor rax, rax
          ret

.its_setup:
          mov r8, rdx  ; Copy str pointer
          mov r10, rdx ; Copy str pointer
          mov r9, rsi  ; Copy base
          mov r13, rdi ; Copy num
          mov r14, rcx ; Copy buf_len

          xor r11, r11 ; Sign
          xor r12, r12 ; bytes_written

          ; Check if num is zero
          cmp r13, 0
          jne .its_not_0 ; If not 0, ignore the next few lines.

          mov [r10], byte 48 ; Write '0' to first char
          inc r10
          mov [r10], byte 0  ; Add 0-terminator
          mov rax, 1
          ret

.its_not_0:
          cmp r13, 0
          jge .its_loop
          
          mov r11, 1
          neg r13

.its_loop:
          ; End loop if num <= 0
          cmp r13, 0
          jle .its_after_loop
          
          ; bytes_written >= buf_len-1
          mov r15, r14
          dec r15
          cmp r12, r15
          jl .its_do_calcs
          ; If (bytes_written >= buf_len-1), there is a problem
          ; so just return here and now.
          mov rax, r12
          ret
          
.its_do_calcs:
          ; rem = num % base
          ; r15 = r13 % r9
          mov rax, r13
          mov rdx, 0
          div r9
          mov r15, rdx
          
          ; Check whether we need a digit (rem <= 9) or a letter (rem > 9)
          cmp r15, 9
          jle .its_need_digit
          
          ; If we are here, rem is >9 and we need a letter
          sub r15, 10 ; Subtract 10, so rem can be between 0 and 26, depending on number and base
          add r15, 65 ; Add 'A', so rem is in 'A'..'Z', depending on the base
          jmp .its_if_need_end

.its_need_digit:
          ; We need a digit and rem is between 0 and 9 (inclusive)
          add r15, 48 ; Add '0', to get the right char

.its_if_need_end:
          mov rax, r15 ; Move r15 into rax so that we can access al (lowest byte in rax)
          mov byte [r10], al ; *buffer = rem
          
          inc r10 ; buffer ++
          inc r12 ; bytes_written ++
          
          ; num = num / base
          mov rax, r13
          mov rdx, 0
          div r9
          mov r13, rax
          
          jmp .its_loop

.its_after_loop:
          cmp r11, 1
          jne .its_append_null
          
          mov byte [r10], 45 ; *buffer = '-'
          inc r10            ; buffer ++
          inc r12            ; bytes_written ++

.its_append_null:
          mov byte [r10], 0  ; *buffer = '\0'
          
          ; reverse (str, bytes_written)
          ; Reverse the input string, NOT the buffer!
          mov rdi, r8
          mov rsi, r12
          call reverse_array
          
          ; return bytes_written
          mov rax, r12
          ret



; Bytewise-reverse array function, made for use in intToStr.
; rdi = array (char*)
; rsi = n (size_t)
;
; rsi = high index
; rcx = low index
; r15 = reg for temporary values
reverse_array:
          cmp rsi, 0
          je .ra_end
          
          dec rsi    ; high = n-1
          mov rcx, 0 ; low = 0
          
.ra_loop:
          cmp rcx, rsi
          jae .ra_end
  
          ; push value from arr[low]
          
          add rdi, rcx
          xor rax, rax
          mov al, byte [rdi]
          push ax
          sub rdi, rcx
          
          ; push value from arr[high]
          add rdi, rsi
          xor rax, rax
          mov al, byte [rdi]
          push ax
          sub rdi, rsi
          
          ; pop value from arr[high] into arr[low]
          add rdi, rcx
          xor rax, rax
          pop ax
          mov al, byte [rdi]
          sub rdi, rcx
          
          ; pop value from arr[low] into arr[high]
          add rdi, rsi
          xor rax, rax
          pop ax
          mov al, byte [rdi]
          sub rdi, rsi
          
          inc rcx
          dec rsi
.ra_end:
          mov rax, 0
          ret
