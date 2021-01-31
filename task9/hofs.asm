; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

global sort
global foo

foo:
  mov rax, 0
  imul rdi, rdi, 2
  ret


;void sort(void *base, size_t nel,
;          int64_t (*compar)(const void *, const void *));
; rdi = base ptr
; rsi = length
; rdx = comparator (a - b)
;
;
;
; r11 = base ptr
; r12 = length
sort:
    push r10
    push r11
    push r12
    
    mov r11, rdi
    mov r12, rsi
    
    mov r8, 1
    xor r9, r9
    xor r10, r10

.start:
    cmp r8, rsi
    jge .end
    
    lea r9, [r11 + r8 * 8]
    
    mov r10, r8
    dec r10
    
    lea rdi, [r11 + r10 * 8]
    lea rsi, [r11 + r8 * 8]
    ;call rdx

.while_start:
    cmp rax, 0
    jbe .while_end
    cmp r10, 0
    jbe .while_end
    
    lea rdi, [r11 + 8 + r10 * 8]
    lea rsi, [r11 + r10 * 8]
    mov rax, [rsi]
    mov [rdi], rax
    dec r10
    
    ;jmp .while_start
    
.while_end:
    lea rdi, [r11 + 8 + r10 * 8]
    mov rax, [r9]
    mov [rdi], rax
    
    inc r8
    ;jmp .start

.end:
    pop r12
    pop r11
    pop r10
    
    ret


;void insertionSort(uint64_t rdi[], size_t rsi,
;                   int64_t (*rdx)(const void *, const void *))  {
;  uint64_t r8 = 1; // i ; Index
;  void* r9 = 0; // key
;  uint64_t r10 = 0; // j ; Also index
;  
;  if (!(r8 < n)) goto end;
;    
;  r9 = (arr + r8 * 8); 
;  r10 = r8 - 1;
;
;  int64_t rax = rdx(arr[r10], r9);
;
;  if (r10 < 0) goto while_end
;  if (rax <= 0) goto while_end
;    
;  arr[r10 + 1] = arr[r10];
;  r10--;
;  
;  while_end:
;
;  arr[r10 + 1] = r9[0];
;  
;  r8++;
;
;  end:
;}
