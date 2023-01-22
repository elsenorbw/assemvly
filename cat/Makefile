

mycat: cat.o
	ld -o mycat cat.o

cat.o: cat.asm
	nasm -f elf64 -o cat.o cat.asm

