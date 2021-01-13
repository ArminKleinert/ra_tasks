; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert


;formula(a, b, c, d, e, f, g, h) {
;  a = a + b;
;  c = c - d;
;  e = e * 8;
;  f = f * 4;
;  g = g / 2;
;  h = h / 4;
;  
;  e = e + f;
;  e = e - g;
;  e = e + h;
;  
;  a = a * c;
;  a = a * e;
;  
;  a = a / 3;
;	return a;
;}


SECTION .data

LC0: DQ 8.0
LC1: DQ 4.0
LC2: DQ 0.5
LC3: DQ 3.0
LC4: DQ 0.25



SECTION .text

global formula_flt
global formula_int

; double check_flt(double a, double b, double c, double d,
;                  double e, double f, double g, double h)
;
; xmm0 = a (a+b; a*c; a*e)
; xmm1 = b 
; xmm2 = c (c-d)
; xmm3 = d
; xmm4 = e (e*8; e+f; f-g; e+h)
; xmm5 = f (f*4)
; xmm6 = g (g/2)
; xmm7 = h (h/4)
;
; Uses floating-point multiplication instead of division because
; it is (presumably) much faster. (eg. (g*0.5) instead of (g/2))
formula_flt:
        addsd xmm0, xmm1 ; a += b
        subsd xmm2, xmm3 ; c -= d
        
        mulsd xmm4, [rel LC0] ; e *= 8
        mulsd xmm5, [rel LC1] ; f *= 4
        mulsd xmm6, [rel LC2] ; g /= 2
        mulsd xmm7, [rel LC4] ; h /= 4
        
        addsd xmm4, xmm5 ; e += f
        subsd xmm4, xmm6 ; e -= g
        addsd xmm4, xmm7 ; e += h
        
        mulsd xmm0, xmm2 ; a *= c
        mulsd xmm0, xmm4 ; a *= e
        
        divsd xmm0, [rel LC3] ; a /= 3
        ret

; int32_t  formula_int(int32_t a, int32_t b, int32_t c, int32_t d,
;                      int32_t e, int32_t f, int32_t g, int32_t h)
;
; rdi = a (a+b)
; rsi = b (c-d)
; rdx = c 
; rcx = d (g/2)
; r8  = e (e*8)
; r9  = f (f*4)
; r10 = g
; r11 = h (h/4)
formula_int_shift:
        mov r10, [rsp+8]
        mov r11, [rsp+16]
        
        add rdi, rsi ; a=a+b
        sub rdx, rcx ; c=c-d
        mov rsi, rdx ; b = c

        ; d = g/2
        sar r10d, 1 ; d = d/2
        sar r11d, 2 ; h = h/4
        shl r8d, 3 ; e = e*8
        shl r9d, 2 ; f = f*4
        
        mov rax, r8 ; rax = e
        add rax, r9 ; rax += f
        sub rax, r10 ; rax -= g
        add rax, r11 ; rax += h
        
        imul rdi ; rax *= a
        xor rdx,rdx
        imul rsi ; rax *= c
        
        ; rax /= 3
        xor rdx, rdx
        mov r8, 3
        idiv r8
        
        ret

;shl == sal == shift left
;sar        == shift right signed
;shr        == shift right unsigned

;1111 1111
;shr 1111 1111  1 == 01111111
;sar 1111 1111  1 == 1111 1111


; int32_t  formula_int(int32_t a, int32_t b, int32_t c, int32_t d,
;                      int32_t e, int32_t f, int32_t g, int32_t h)
;
; rdi = a (a+b)
; rsi = b (c-d)
; rdx = c 
; rcx = d (g/2)
; r8  = e (e*8)
; r9  = f (f*4)
; r10 = g
; r11 = h (h/4)
; r12 = c
formula_int_old:
        mov r10, [rsp+8]
        mov r11, [rsp+16]
        
        add edi, esi ; a=a+b
        sub edx, ecx ; c=c-d
        mov esi, edx ; b = c
        
        ; d = d/2
        mov eax, r10d
        cdq
        mov r10d, 2
        idiv r10d
        mov r10d, eax
        
        ; h = h/4
        mov eax, r11d
        cdq
        mov r11d, 4
        idiv r11d
        mov r11d, eax
        
        imul r8d, r8d, 8 ; e = e*8
        imul r9d, r9d, 4 ; f = f*4
        
        mov eax, r8d ; rax = e
        add eax, r9d ; rax += f
        sub eax, r10d ; rax -= g
        add eax, r11d ; rax += h
        
        imul edi ; rax *= a
        imul esi ; rax *= c
        
        ; rax /= 3
        cdq
        mov r8d, 3
        idiv r8d
        
        ret




formula_int:; get the 7th and 8th argument
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

		test eax, eax
		js .signed3
		
		xor edx, edx	; edx all 0 if unsigned
		jmp .div3
		
.signed3:
    mov edx, -1
.div3:
		mov esi, 3
		idiv esi	; eax = eax / 3

		ret
