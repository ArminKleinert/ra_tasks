; Abgabe von: Ruth Höner zu Siederdissen und Armin Kleinert

; Reihenfolge Register: rdi, rsi, rdx, rcx, r8, r9

; calc_add(float f0, float f1)
; xmm0 = f0 (rdi)
; xmm1 = f1 (rsi)

; r8 = f0 mantissa
; r9 = f1 mantissa
; r10 = f0 exponent
; r11 = f0 exponent
          global calc_add
calc_add:
          xor rax, rax
          xor rdx, rdx
          movd eax, xmm0
          movd edx, xmm1

.ca_start:
          xor r9, r9
          xor r11, r11
  
          ; Exponent f1
          mov r9d, eax
          shr r9, 23
          and r9, 0xFF
  
          ; Exponent f1
          mov r11d, edx
          shr r11, 23
          and r11, 0xFF
  
          ; Reverse so that f0 <= f1
          cmp r9, r11
          jbe .ca_calc_mantissa
          push rax
          mov eax, edx
          pop rdx
          ja .ca_start
  
.ca_calc_mantissa:

          xor r8, r8
          xor r10, r10
  
          ; Mantisse f0
          mov r8d, eax
          and r8, 0x7FFFFF
          or r8, 0x800000 ; Hidden bit
  
          ; Mantisse f0
          mov r10d, edx
          and r10, 0x7FFFFF
          or r10, 0x800000 ; Hidden bit

.ca_adjust:
          cmp r11, 0
          jbe .ca_adjust_end
          shr r8, 1
          dec r9
          ja .ca_adjust
          
.ca_adjust_end:

          ; Optionally handle signs here...
          
          ; Add mantissas
          add r8, r10
          
          ; Remove hidden bit
          and r8, 0x7FFFFF
          
          ; Normalisation
          add r9, 1
          shr r8, 8
          
.ca_normalize:
          jc .ca_normalize_end
          dec r9
          shr r8d, 1
          jmp .ca_normalize
          
.ca_normalize_end:
          shr r8, 9
          shl r9, 23
          or r8, r9
          ; Also insert sign later...
          
.ca_end:
          mov rax, r8
          movd xmm0, eax
          ret
