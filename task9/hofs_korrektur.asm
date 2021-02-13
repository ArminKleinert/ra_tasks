; Abgabe von: Armin Kleinert und Ruth Höner zu Siederdissen

; Gianluca: Was soll ich sagen? Schöner code!
; 3/3

global sort

; Params:
; rdi = start array
; rsi = num elements
; rdx = pointer function

; Register Use:

; non-volatile
; r12 = start array
; r13 = i
; r14 = pointer function
; r15 = j

; volatile
; rcx = i-1
; rdi = rsi = params compare function and temps

sort:		push r12	; stack misaligned
		push r13	; stack aligned
		push r14	; stack misaligned
		push r15	; stack aligned

		mov r12, rdi	; r12 = start array
		mov r13, rsi	; r13 = num elem.
		mov r14, rdx	; r14 = pointer function

.outer:		cmp r13, 1	; i > 0 ?
		jbe .end

		mov r15, 0	; j = 0
		mov rcx, r13	; rcx = i
		dec rcx		; rcx = i-1

.inner:		cmp r15, rcx	; j < i-1
		jae .end_inner

.if:		lea rdi, [r12 + r15*8]		; rdi = address of A[j]
		lea rsi, [r12 + r15*8 + 8] 	; rsi = adress of A[j+1]
		push rcx			; stack misaligned
		call r14			; stack aligned
		pop rcx				; stack aligned
		cmp rax, 0
		jle .end_if

		; Gianluca: Ich glaube hier müsste man theoretisch die register nicht
		; noch einmal laden, da diese als const * definiert sind (oder?)
		mov rdi, [r12 + r15*8]		; rdi = A[j]
		mov rsi, [r12 + r15*8+8]	; rsi = A[j+1]
		mov [r12 + r15*8], rsi		; A[j] = A[j+1]
		mov [r12 + r15*8+8], rdi	; A[j+1] = A[j]

.end_if:	inc r15		; j++
		jmp .inner

.end_inner:	dec r13		; i--
		jmp .outer

.end:		pop r15
		pop r14
		pop r13
		pop r12

		ret
