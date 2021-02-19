c99 -O2 -c -o wrapper.o wrapper.c
nasm -f elf64 -o drehdichum.o drehdichum.asm
c99 -o drehdichum drehdichum.o wrapper.o

