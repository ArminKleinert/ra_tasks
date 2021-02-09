;Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert

global _start

%define sys_exit 60
%define sys_read 0
%define stdin 0
%define sys_write 1
%define stdout 1
%define buf_max 1024

section .bss
buf: resb buf_max

section .text

; Register Use
; r12 = bytes read
; r13 = bytes written
; r14 = buf + offset
; rcx = nread - nwritten

_start:		push r12		; misaligned
		push r13		; aligned
		push r14		; misaligned

.read:		mov rax, sys_read	; rax = 0
		mov rdi, stdin		; rdi = 0
		mov rsi, buf		; rsi = adress buf
		mov rdx, buf_max	; rdx = 1024
		syscall

		cmp rax, 0		; rax = 0?
		je .end_success		; yes -> .end
		jl .end_error		; negative -> .end_error

		mov r12, rax		; r12 = bytes read
		mov r13, 0		; r13 = bytes written (0)
		mov r14, buf		; r14 = adress buf

.write:		cmp r13, r12		; bytes written = bytes read?
		jae .read		; all written -> .read

		add r14, r13		; r14 = adress buf + offset
		mov rcx, r12		; rcx = bytes read
		sub rcx, r13		; rcx = bytes read - bytes written

		mov rax, sys_write	; rax = 1
		mov rdi, stdout		; rdi = 1
		mov rsi, r14		; rsi = adress buf (incl. offset)
		mov rdx, rcx		; rdx = bytes to write
		syscall

		cmp rax, -1		; rax = -1?
		je .end_error		; yes -> .end_error
		add r13, rax		; r13 = r13 + bytes written
		jmp .write		; write more -> .write

.end_error:	mov rdi, 1		; error
		jmp .end

.end_success:	mov rdi, 0		; no error

.end:		pop r14
		pop r13
		pop r12
		mov rax, sys_exit	; rax = 60
		syscall
