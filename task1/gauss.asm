; (n * (n + 1)) / 2
          global gauss
gauss:    mov rax, rdi ; rax = rdi
          add rdi, 1   ; rdi += 1
          mul rdi      ; rax *= rdi
          mov rcx, 2   ; rcx = 2
          div rcx      ; rax /= rcx
          ret
