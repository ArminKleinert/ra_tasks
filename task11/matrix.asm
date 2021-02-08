; Abgabe von Ruth Höner zu Siederdissen und Armin Kleinert

section .bss

section .text

global asmRowAdd
global asmColAdd


; rdi : int64_t* matrix
; rsi : uint64_t m (number of cells)
; rdx : uint64_t n (number of rows)
;
; Access to a cell at (x,y): matrix[n*y+x]
; Sums cols of matrix.
;
; Average time in us: 531.0
; Median time in us:  414.1
; Average cycles:     600
; Median cycles:      506
asmColAdd:
        ; If the matrix has 0 rows
        test    rdx, rdx
        je      .noRows
        
        mov     r9, rdx
        
        ; Number of bytes to skip from column to column.
        ; For the default number of cells per column (512) 
        ; times 8 (because each cell is 8 bytes in size).
        ; Or 4096 bytes for short.
        mov     r10, r9
        shl     r10, 3
        
        mov     rdx, rsi
        xor     ecx, ecx
        xor     r8d, r8d
        sal     rdx, 12
        add     rdx, rdi
        mov     rdi, rsi
        neg     rdi
        sal     rdi, 12
.L3:
        lea     rax, [rdx+rdi]
        test    rsi, rsi
        je      .L6
.L4:
        add     r8, QWORD [rax]
        add     rax, r10 ; Go to next column
        cmp     rax, rdx
        jne     .L4
.L6:
        add     rcx, 1
        add     rdx, 8
        cmp     r9, rcx
        jne     .L3
        mov     rax, r8
        ret
.noRows:
        xor     r8d, r8d
        mov     rax, r8
        ret


; rdi : int64_t* matrix
; rsi : uint64_t m (number of cells)
; rdx : uint64_t n (number of rows)
;
; Access to a cell at (x,y): matrix[n*y+x]
; Sums rows of matrix.
;
; Average time in us: 265.3
; Median time in us:  188.77777777777777
; Average cycles:     188
; Median cycles:      186
asmRowAdd:
        ; If the matrix has 0 cells per row
        test    rsi, rsi
        je      .noCells
        
        mov     rax, rdi
        mov     rdi, rsi
        mov     rsi, rdx
        
        ; Number of bytes to skip from row to row.
        ; For the default number of cells per row (512) 
        ; times 8 (because each cell is 8 bytes in size).
        ; Or 4096 bytes for short.
        mov     r10, rdi
        shl     r10, 3
        
        mov     r9, rsi
        lea     rdx, [rax+rdx*8]
        xor     ecx, ecx
        xor     r8d, r8d
        neg     r9
        sal     r9, 3
.L13:
        lea     rax, [rdx+r9]
        test    rsi, rsi
        je      .L16
.L14:
        add     r8, QWORD [rax]
        add     rax, 8
        cmp     rax, rdx
        jne     .L14
.L16:
        add     rcx, 1
        add     rdx, r10 ; Go to next row
        cmp     rdi, rcx
        jne     .L13
        mov     rax, r8
        ret
.noCells:
        xor     r8d, r8d
        mov     rax, r8
        ret



