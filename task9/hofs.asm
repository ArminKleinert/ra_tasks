; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

global sort

;void sort(void *base, size_t nel,
;          int64_t (*compar)(const void *, const void *));
; rdi = base ptr
; rsi = length
; rdx = comparator (a - b)
;
; r8 = length; // i
; r9 = 0; // j
; r10 = 0; // temp2
; r12 = A
; r13 = rdx; // Comparator
; r11 = length
; rax, rdi and rsi are also used as intermediates
sort:
          push r8
          push r9
          push r10
          push r11
          push r12
          push r13
          
          mov r8, rsi ; // i
          mov r12, rdi ; A
          mov r13, rdx ; compar

          ;xor r9, r9 ; j
          xor r10, r10 ; temp2

.outer:
          ; Contiue if r8>1
          cmp r8, 1
          jle .end

          ; Set r9 = 0
          xor r9, r9

.inner:
          ; r10=i-1
          mov r10, r8
          dec r10
          
          ; Continue if r9 < 10
          cmp r9, r10
          jge .inner_end

           ; Call comparator
           lea rdi, [r12+r9*8]
           lea rsi, [r12+r9*8+8]
 
           push r8
           push r9
           push r10
           push r11
           call r13
           pop r11
           pop r10
           pop r9
           pop r8
           
           ; Swap condition: rax > 0
           ; So no swap if rax <= 0
           cmp rax, 0
           jle .if_end
          
          ; Swap A[j] and A[j+1]
          lea rdi, [r12+r9*8]
          lea rsi, [r12+r9*8+8]
          mov rax, [rdi]
          mov r10, [rsi]
          mov [rdi], r10
          mov [rsi], rax

.if_end:
          inc r9 ; j++
          jmp .inner

.inner_end:
          dec r8 ; i--
          jmp .outer

.end:
          pop r13
          pop r12
          pop r11
          pop r10
          pop r9
          pop r8
          
          ret



















