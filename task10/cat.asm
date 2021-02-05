; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

%define sys_exit    60
%define sys_read    0
%define sys_write   1
%define stdin       0
%define stdout      1

%define buff_max    1024

section .bss

buffer: resb buff_max ; Everything after contains the actual code.


section .text

; Overview of used system calls.
; rax | name      | ret             | rdi    | rsi        | rdx
; 0   | sys_read  | size_t nread    | u32 fd | char* buff | size_t count
; 1   | sys_write | size_t nwritten | u32 fd | char* buff | size_t count
; 60  | sys_exit  | i32 error       | -      | -          | -

global _start

; Function for writing from buffer to stdout
; rdi : Number of bytes to write.
writeAll:
          mov rdx, rdi ; Bytes to write
          mov rsi, buffer ; Put buffer 
          mov rdi, stdout
.wa_start:
          ; Write. All parameters except rax were set above
          mov rax, sys_write
          syscall

          ; Check for error
          cmp rax, 0
          jle .wa_error

          add rsi, rax ; Advance pointer
          sub rdx, rax ; Decrease remaining bytes to write
          
          ; Check whether or not we are done
          cmp rax, r12
          jl .wa_start
.wa_error:
          ; Either we have an error or everything was printed
          ret

; Function for reading from stdin.
fromStdin:
          ; Prepare system read
          mov rax, sys_read
          mov rdi, stdin
          mov rsi, buffer
          mov rdx, buff_max
          syscall

          ; Check for error or no input.
          cmp rax, 0
          jle .ra_error
          
          ; Write bytes.
          mov rdi, rax
          call writeAll

          ; Go to beginning.
          ; This automatically covers the case that more bytes
          ; were pushed to input than what could be read.
          jmp fromStdin
.ra_error:
          ret

_start:
          call fromStdin
          mov rax, sys_exit
          mov rdi, 0
          syscall




