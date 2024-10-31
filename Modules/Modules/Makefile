all:
	as -o lib.o GpuLib.s
	gcc -Wall -w test_sprites.c  board.c  buttons.c draw.c layouts.c tetromino.c lib.o -o exec -pthread -lintelfpgaup -std=c99
	sudo ./exec

all:
	as -o lib.o GpuLib.s
	gcc -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c lib.o -o exec -pthread -lintelfpgaup -std=c99
	sudo ./exec
	
