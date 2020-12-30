; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert

global formula_flt
global formula_int
global formula_int_shift

formula_flt:
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
; r12 = intermediate for g/2, h/4, e*8 and f*4
formula_int:
        mov r10, [rsp+8]
        mov r11, [rsp+16]
        
        add rdi, rsi ; a=a+b
        sub rdx, rcx ; c=c-d
        mov rsi, rdx ; b = c

        ; d = g/2
        mov rax, r10 ; get g
        xor rdx, rdx ; rdx = 0
        mov r12, 2
        idiv r12     ; rdx:rax = rax/2
        mov rcx, rax ; d = g/2
        ; rest is in rdx

        ; h = h/4
        mov rax, r11 ; get h
        xor rdx, rdx ; rdx = 0
        mov r12, 4
        idiv r12     ; rax = rax/4
        mov r11, rax ; h = h/4
        ; rest is in rdx

        ; e = e*8
        xor rdx, rdx ; rdx = 0
        mov rax, r8 ; get e
        xor rdx, rdx ; rdx = 0
        mov r12, 8
        imul r12     ; rax = rax*8
        mov r8, rax ; e = rax

        ; f = f*4
        xor rdx, rdx ; rdx = 0
        mov rax, r9 ; get f
        xor rdx, rdx ; rdx = 0
        mov r12, 4
        imul r12     ; rax = rax*4
        mov r9, rax ; f = rax
        
        mov rax, r8 ; rax = e
        add rax, r9 ; rax += f
        sub rax, rcx ; rax -= g
        add rax, r11 ; rax += h
        
        imul rdi ; rax *= a
        xor rdx,rdx
        imul rsi ; rax *= c
        
        ; rax /= 3
        xor rdx, rdx
        mov r12, 3
        idiv r12
        xor rdx, rdx
        
        ret



; rdi = a (a+b)
; rsi = b (c-d)
; rdx = c 
; rcx = d (g/2)
; r8  = e (e*8)
; r9  = f (f*4)
; r10 = g
; r11 = h (h/4)
; r12 = intermediate for g/2, h/4, e*8 and f*4

; int rdi = a;
; int rsi = b;
; int rdx = c;
; int rcx = d;
; int r8 = e;
; int r9 = f;
; int r10 = g
;
; rdi = rdi + rsi;
; rsi = rdx - rcx;
; r8 = r8 * 8;
; r9 = r9 * 4;
; rcx = r10 / 2;
; r11 = r11 / 4;
;  
; rax = r8
; rax = rax + r9;
; rax = rax - r10;
; rax = rax + r11;
;  
; rax = rax * rdi;
; rax = rax * rsi;
;  
; rax = rax / 3;
; return rax;




; int32_t  formula_int(int32_t a, int32_t b, int32_t c, int32_t d,
;                      int32_t e, int32_t f, int32_t g, int32_t h)
;
; rdi = a
; rsi = b
; rdx = c
; rcx = d
; r8  = e
; r9  = f
; r10 = g
; r11 = h
formula_int_shift:
        mov rax, r9
        and rax, 0xFFFF
        ret

