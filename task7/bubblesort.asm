; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert



SECTION .text

global sort

; rdi = len
; rsi = arraay
; r8 = i
; r9 = j
; r10, rcx,  = intermediate
sort:
	mov r8, rdi ; i = len
	;mov r9, 0 ; j = 0
	mov r11, 8

.for_head:
	mov r9, 0   ; j=0
	dec r8      ; i-=1	
	cmp r8, 0   ; if i == 0 jump to result
	je result

.for_inner:
	cmp r9, r8  ; i == j => Return to outer loop
	je .for_head
	mov rax, r9
	mul r11
	mov r10, [rsi+rax] ;r10=A[j]
	inc r9 ;j += 1
	mov rax, r9
	mul r11
	mov rcx, [rsi+rax]	;rcx = A[j+1]
	cmp r10, rcx		
	jl .for_inner		; No switch

	; Do the switch
	dec r9
	mov rdi, r10		;tmp=A[j]	
	mov rax, r9
	mul r11
	mov [rsi+rax], rcx	;A[j]=A[j+1]
	inc r9
	mov rax, r9
	mul r11
	mov [rsi+rax], rdi
	
	jmp .for_inner

result:
	ret

