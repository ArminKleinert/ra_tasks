# ra_tasks  
Repo for tasks in the computer architecture course.  

Usage for compile.sh:  
``./compile.sh <asm-file-name> <c-file-name> <source-dir>``  
The filenames need to be given without the extension:
``./compile.sh gauss gauss_wrapper task1``  
  
To execute the executable in the same command:  
``./compile.sh <asm-file-name> <c-file-name> <source-dir> ``
Example:  
``./compile.sh gauss gauss_wrapper task1 && ./gauss 10``

If there is an error, this should be done step by step:  
```
cd task1
nasm -f elf64 -o gauss.o gauss.asm
c99 -O2 -c -o gauss_wrapper.o gauss_wrapper.c
c99 -o gauss gauss_wrapper.o gauss.o
./gauss 10                                    # optional
cd ..                                         # optional
```

