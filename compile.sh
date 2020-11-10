#!/bin/bash

# compile asm part
nasm -f elf64 -o deleteme_asm.o $3/$1.asm
# compile c-wrapper
c99 -O2 -c -o deleteme_c.o $3/$2.c
# link
c99 -o $1 deleteme_c.o deleteme_asm.o

# remove temporary files
rm deleteme_c.o
rm deleteme_asm.o
