c99 -O2 -c -o hofs_wrapper hofs_wrapper.c
nasm -f elf64 -o hofs.o hofs.asm
c99 -o hofs hofs.o hofs_wrapper

