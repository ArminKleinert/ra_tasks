; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert

global formula_int_old	; without shift
global formula_int	; with shift
global formula_flt

; Formel: (((a+b)*(c-d))*(e*8+f*4-g/2+h/4))/3

SECTION .data
eight: dq 8.0
four: dq 4.0
two: dq 2.0
three: dq 3.0

SECTION .text

; params:
; a = edi
; b = esi
; c = edx
; d = ecx
; e = r8d
; f = r9d
; g = stack => r10d
; h = stack => r11d

; register use:
; edi = (a+b)
; ecx = (c-d)
; r8d = (e*8)
; r9d = (f*4)
; r10d = (g/2)
; r11d = (h/4)
; esi = single values for imul/idiv

; integer calculation

formula_int_old:; get the 7th and 8th argument
		mov r10d, [rsp+8]
		mov r11d, [rsp+16]

		add edi, esi 	; edi = (a+b)
		sub edx, ecx	; edx = (c-d)
		mov ecx, edx	; ecx = (c-d)

		mov eax, r8d	; eax = e
		mov esi, 8
		imul esi	; eax = (e*8)
		mov r8d, eax	; r8d = (e*8)

		mov eax, r9d	; eax = f
		mov esi, 4
		imul esi	; eax = (f*4)
		mov r9d, eax	; r9d = (f*4)

		mov eax, r10d	; eax = g

		test eax, eax
		js .signed1

		XOR edx, edx	; edx all 0 if unsigned
		jmp .div1	; edx all 1 if signed

.signed1:	mov edx, -1

.div1:		mov esi, 2
		idiv esi	; eax = (g/2)
		mov r10d, eax	; r10d = (g/2)

		mov eax, r11d	; eax = h

		test eax, eax
		js .signed2

		XOR edx, edx	; edx all 0 if unsigned
		jmp .div2

.signed2:	mov edx, -1	; edx all 1 if signed

.div2:		mov esi, 4
		idiv esi	; eax = (h/4)
		mov r11d, eax	; r11d = (h/4)

		mov eax, r8d	; eax = (e*8)
		add eax, r9d	; eax = (e*8) + (f*4)
		sub eax, r10d	; eax = (e*8) + (f*4) - (g/2)
		add eax, r11d	; eax = (e*8) + (f*4) - (g/2) + (h/4)

		imul edi	; eax = eax * (a+b)
		imul ecx	; eax = eax * (c-d)

		mov esi, 3
		idiv esi	; eax = eax / 3

		ret

; integer calculation with shift

formula_int:	; get the 7th and 8th argument
		mov r10d, [rsp+8]
		mov r11d, [rsp+16]

		add edi, esi 	; rdi = (a+b)
		sub edx, ecx	; rdx = (c-d)
		mov ecx, edx	; rcx = (c-d)

		shl r8d, 3	; shift left 3 times = (e*8)

		shl r9d, 2	; shift left 2 times = (f*4)

		sar r10d, 1	; shift right 1 time = (g/2)

		sar r11d, 2	; shift right 2 times = (h/4)

		mov eax, r8d	; rax = (e*8)
		add eax, r9d	; rax = (e*8) + (f*4)
		sub eax, r10d	; rax = (e*8) + (f*4) - (g/2)
		add eax, r11d	; rax = (e*8) + (f*4) - (g/2) + (h/4)

		imul edi	; rax = rax * (a+b)
		imul ecx	; rax = rax * (c-d)

		mov esi, 3
		idiv esi	; rax = rax / 3

		ret

; Floating Point calculation

; params:
; a = xmm0
; b = xmm1
; c = xmm2
; d = xmm3
; e = xmm4
; f = xmm5
; g = xmm6
; h = xmm7

; register use
; xmm1 = (a+b)
; xmm2 = (c-d)
; xmm4 = (e*8)
; xmm5 = (f*4)
; xmm6 = (g/2)
; xmm7 = (h/4)

formula_flt:	addsd xmm1, xmm0	; xmm1 = (a+b)
		subsd xmm2, xmm3	; xmm2 = (c-d)

		mulsd xmm4, [rel eight]	; xmm4 = (e*8)
		mulsd xmm5, [rel four]	; xmm5 = (f*4)
		divsd xmm6, [rel two]	; xmm6 = (g/2)
		divsd xmm7, [rel four]	; xmm7 = (h/4)

		movsd xmm0, xmm4	; xmm0 = (e*8)
		addsd xmm0, xmm5	; xmm0 = (e*8)+(f*4)
		subsd xmm0, xmm6	; xmm0 = (e*8)+(f*4)-(g/2)
		addsd xmm0, xmm7	; xmm0 = (e*8)+(f*4)-(g/2)+(h/4)

		mulsd xmm0, xmm1	; xmm0 = xmm0 * (a+b)
		mulsd xmm0, xmm2	; xmm0 = xmm0 * (c-d)

		divsd xmm0, [rel three]	; xmm0 = xmm0/3

		ret
