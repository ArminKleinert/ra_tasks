

global  function

function:   
    mov rax , rsi
    add rax , rdi
    sub rax , 1
    
.loop:       
    cmp rax , rsi
    jbe .end
    
    mov r8b , [rsi]
    mov r9b , [rax]
    mov [rax], r8b
    mov [rsi], r9b
    
    inc rsi
    dec rax
    
    jmp .loop
    
.end:
    ret
