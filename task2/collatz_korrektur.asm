; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert
global collatz

; 1st argument rdi
; n = rax
; k = rcx
; return rax

; Gianluca: An sich funktioniert es, aber ihr habt ein paar Sachen gemacht, die nicht nötig gewesen wären.
; .is_even hätte man einfach als ein einfaches TEST rax implementieren können.
; Zudem beachtet ihr hier auch nicht die Calling Convention für .is_even.

; Wenn ihr schon so auf Optimierung aus seit, dann aber richtig :P

; 3 / 3

collatz:	; Gianluca: Tip XOR rcx, rcx <=> MOV rcx, 0
	 	mov rcx, 0	; rcx := 0
		mov rax, rdi	; rax := rdi
		mov rdx, 0 ;                        <= Hier

.while:		cmp rax, 1
		jbe .afterwhile	; jump to afterwhile if rax <= 1

		push rdx
		push rax	; preserve value of rax
		; Gianluca: Interessant, dass ihr hier eine eigene Funktion für geschrieben habt
		; Aber das wäre nicht nötig gewesen.
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

; Gianluca: Wenn das eine eigene Funktion ist, dann nicht den '.' prefix
; Zudem müsste '.afterwhile:' dann davor kommen
; is_even müsste nach der Logik einen Bool also 0 oder 1 returnen. Hier fehlt also das MOV rax, rdx (wenn man die Calling-Convention beachtet).
.is_even:	;mov rdx, 0	; 64 leading zeros
		mov rsi, 2	; rsi := 2
		div rsi
		ret		; return to call

.afterwhile:	mov rax, rcx
		ret		; return to wrapper


