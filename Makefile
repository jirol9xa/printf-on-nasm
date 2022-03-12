CC = nasm -f elf64


all: build

build: ITOA.o STRCHR.o STRLEN.o printf.o switch.o
	ld -s ITOA.o STRCHR.o STRLEN.o printf.o switch.o -o printf
clear:
	rm -rf *.o


ITOA.o:	  ITOA.asm
	$(CC) ITOA.asm
STRCHR.o: STRCHR.asm
	$(CC) STRCHR.asm
STRLEN.o: STRLEN.asm
	$(CC) STRLEN.asm
printf.o: printf.asm
	$(CC) printf.asm
switch.o: switch.asm
	$(CC) switch.asm