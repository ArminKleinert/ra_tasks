c99 -O0 -c -o formula_wrapper.o formula_wrapper.c
nasm -f elf64 -o formula.o formula.asm
c99 -o formula formula.o formula_wrapper.o

