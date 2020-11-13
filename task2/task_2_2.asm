          global test
test:     cmp rdi, 10
          jne _s1

_s1:      mov rdi, 1
          ret

          global test2
test2:    sub x, 10
          jz _s2

_s2:      mov rdi, 1
          ret

