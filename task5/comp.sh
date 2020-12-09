c99 -O2 -c -o fib_wrapper.o fib_wrapper.c
nasm -f elf64 -o fib.o fib.asm
c99 -o fib fib.o fib_wrapper.o

