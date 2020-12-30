c99 -O2 -c -o bubblesort_wrapper.o bubblesort_wrapper.c
nasm -f elf64 -o bubblesort.o bubblesort.asm
c99 -o bubblesort bubblesort.o bubblesort_wrapper.o

