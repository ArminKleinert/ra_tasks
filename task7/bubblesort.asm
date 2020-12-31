; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert



SECTION .text

global sort


; Get nth element in array of 64-bit elements.
; rdi = array
; rsi = index
nth_64:
          shl rsi, 3
          add rdi, rsi
          mov rax, [rdi]
          ret

; Set nth element in array
; rdi = array
; rsi = index
; rdx = element
set_nth_64:
          shl rsi, 3
          add rdi, rsi
          mov [rdi], rdx
          mov rax, rdx
          ret

; sort (uint64_t len, int64_t a[len])
; rdi = len (only initially)
; rsi = a (only initially)
; r8 = i
; r9 = j
; r10 = array
; r11 = len
; r12 = temporary
sort:
          mov r8, rdi ; i = len
          mov r10, rsi
          mov r11, rdi
          
          push r12
          
.sort_for_i:
          ; i > 1
          cmp r8, 1
          jle .end_sort
          
          xor r9, r9  ; j = 0
.sort_for_j:          
          ; j < i-1
          cmp r9, r8
          jge .sort_for_j_end
          
          ; Get element at a[j] (into r12)
          mov rdi, r10
          mov rsi, r9
          call nth_64
          mov r12, rax
          
          ; get A[j+1]
          mov rdi, r10
          mov rsi, r9
          inc rsi
          call nth_64
          
          ; A[j] > A[j+1] or jump to .if_end
          cmp r12, rax
          jle .if_end
          
          ; temp = A[j]
          ; NOP since r12 is already in r12
          
          ; A[j] = A[j+1]
          mov rdi, r10
          mov rsi, r9
          mov rdx, rsi
          inc rdx
          call set_nth_64 
          
          ; A[j+1] = temp
          mov rdi, r10
          mov rsi, r9
          mov rdx, r12
          call set_nth_64 
          
.if_end:
          inc r9
          jmp .sort_for_j
          
.sort_for_j_end:
          dec r8 ; i --
          jmp .sort_for_i
          
.end_sort:
          mov rax, r9
          pop r12
          ret

