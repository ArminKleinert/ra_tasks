c99 -O2 -c -o matrix_wrapper matrix_wrapper.c
nasm -f elf64 -o matrix.o matrix.asm
c99 -o matrix matrix.o matrix_wrapper

