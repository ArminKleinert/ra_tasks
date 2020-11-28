; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert
global strToInt

; Params:
; *str = rdi
; base = rsi

; register use
; rcx = counter (i)
; r8 = s
; cl = current ascii

strToInt:	xor rax, rax	; zero rax
		xor rcx, rcx	; 0 rcx
		mov cl, [rdi]	; load first character in cl

		cmp rsi, 1
		jbe .error	; do nothing if base <= 1
		cmp rsi, 36
		ja .error	; do nothing if base > 36

		cmp cl, 45	; check if '-'
		je .neg		; negative number
		cmp cl, 43	; check if '+'
		je .pos		; positive number with sign
		mov r8, 0	; positive number without sign
		jmp .start_calc

.neg:		mov r8, 1	; set sign to negative
		inc rdi		; increment address
		jmp .start_calc

.pos:		mov r8, 0	; set sign to positive
		inc rdi		; increment address

.start_calc:	mov cl, [rdi]	; load next character
		cmp cl, 0
		je .end_calc	; terminating character

		cmp cl, 97
		jae .lowercase	; lowercase letter
		cmp cl, 65
		jae .uppercase	; uppercase letter
		sub cl, 48	; should be 0-9

.calc:		cmp rcx, rsi
		jae .error	; return 0 if character is used that is not supposed to be in the base

		mul rsi		; multiply by base
		add rax, rcx	; add digit
		inc rdi		; increment address
		jmp .start_calc

.lowercase:	sub cl, 87	; convert lowercase to integer
		jmp .calc

.uppercase:	sub cl, 55	; convert uppercase to integer
		jmp .calc

.error:		xor rax, rax	; set rax to 0
		jmp .end

.end_calc:	cmp r8, 0
		je .end
		mov rsi, -1
		imul rsi	; multiply rax with -1 to get negative result

.end:		ret
