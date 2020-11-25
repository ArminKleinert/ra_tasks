; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert
global collatz

; 1st argument rdi
; n = rax
; k = rcx
; return rax

collatz: 	mov rcx, 0	; rcx := 0
		mov rax, rdi	; rax := rdi
		mov rdx, 0 ;                        <= Hier

.while:		cmp rax, 1
		jbe .afterwhile	; jump to afterwhile if rax <= 1

		push rdx
		push rax	; preserve value of rax
		call .is_even	; call .is_even
		pop rax		; rax back to n

		cmp rdx, 0	; compare rest of division
		pop rdx
		jne .else	; jump to else if not equal
		mov rsi, 2
		div rsi		; rax := n /= 2
		jmp .afterif	; jump to afterif

.else:		mov rsi, 3
		mul rsi		; rax := n *= 3
		add rax, 1	; rax := n++

.afterif:	add rcx, 1
		jmp .while

.is_even:	;mov rdx, 0	; 64 leading zeros
		mov rsi, 2	; rsi := 2
		div rsi
		ret		; return to call

.afterwhile:	mov rax, rcx
		ret		; return to wrapper


