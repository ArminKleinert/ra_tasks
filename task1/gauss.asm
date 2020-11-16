          global gauss
gauss:    mov rax, rdi ; rax = rdi
          add rdi, 1   ; rdi += 1
          mul rdi      ; rax *= rdi
          mov rdx, 0
          mov rcx, 2   ; rcx = 2
          div rcx      ; rax /= rcx
          ret
