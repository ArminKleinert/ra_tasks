; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

%define sys_exit    60
%define sys_read    0
%define sys_write   1
%define stdin       0
%define stdout      1

%define buff_max    1024

; Calls sys_read with stdin and the following arguments:
; 1. buffer : char*
; 2. nbytes : number of bytes to read
%macro call_read 2
          mov rax, sys_read
          mov rdi, stdin
          mov rsi, %1
          mov rdx, %2
          syscall
%endmacro


; Calls sys_write with stdout the following arguments:
; 1. buffer : char*
; 2. nbytes : number of bytes to write
%macro call_write 2
          mov rax, sys_write
          mov rdi, stdout
          mov rsi, %1
          mov rdx, %2
          syscall
%endmacro

section .bss

buffer: resb buff_max ; everything after contains the actual code


section .text

; rax | name      | ret             | rdi    | rsi        | rdx
; 0   | sys_read  | size_t nread    | u32 fd | char* buff | size_t count
; 1   | sys_write | size_t nwritten | u32 fd | char* buff | size_t count
; 60  | sys_exit  | i32 error       | -      | -          | -

global _start

; PROGRAMM IST FALSCH
; read und write müssen direkt aufeinander folgen! (Für den Fall, dass mehr
; Input kommt als der Buffer aufnehmen kann.)

writeAll:
.wa_start:
          mov r12, rdi ; Bytes to write
          mov r13, buffer

          call_write buffer, r12

          cmp rax, 0
          jle .wa_error

          add r13, rax
          sub r12, rax
          cmp rax, r12
          jl writeAll
.wa_error:
          ret

fromStdin:
          call_read buffer, buff_max

          mov rdi, rax
          call writeAll
          jmp fromStdin
.ra_error:
          ret

_start:
          call fromStdin
          mov rax, sys_exit
          mov rdi, 0
          syscall

;loop do
;stat = readStdin buffer, buff_max
;
;break if rax < 0 ; Error
;break if rax == 0 ; No input
;
;writeAll buffer, stat
;end




