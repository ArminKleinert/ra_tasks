; Abgabe von: Armin Kleinert und Ruth Höner zu Siederdissen

; Gianluca: Sieht gut aus :D
; 3/3

global gauss

gauss:    mov rax, rdi ; rax = rdi
          add rdi, 1   ; rdi += 1
          mul rdi      ; rax *= rdi
	  ; Gianluca: Das Move rdx = 0 ist nicht Notwendig!
	  ; Ihr macht ja direkt nach der Multiplikation ein Div
	  ; Das könnte sogar zu Fehlergebnissen führen
          mov rdx, 0
          mov rcx, 2   ; rcx = 2
          div rcx      ; rax /= rcx
          ret
