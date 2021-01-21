; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

global sort

; Params:
; rdi = length
; rsi = array_start

; Register use:
; rdi = i
; rcx = j
; rdx = i-1
; r8 = A[j+1]
; r9 = A[j]

sort:

.outer:		cmp rdi, 1	; i > 1 ?
          jbe .end

          mov rcx, 0	; j = 0
          mov rdx, rdi	; r9 = i
          dec rdx		; r9 = i-1

.inner:		cmp rcx, rdx	; j < i-1 ?
          jae .end_inner

.if:		  mov r8, [rsi+(rcx+1)*8]		; rdx = A[j+1]
          cmp [rsi+rcx*8], r8		; A[j] > A[j+1] ?
          jbe .end_if

          mov r9, [rsi+rcx*8]		; r8 = A[j]
          mov [rsi+rcx*8], r8		; A[j] = A[j+1]
          mov [rsi+(rcx+1)*8], r9		; A[j+1] = r8

.end_if:	inc rcx		; j++
          jmp .inner

.end_inner:	dec rdi		; i--
          jmp .outer

.end:		  ret
