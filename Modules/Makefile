all:
	as -o GpuLib.o GpuLib.s
	gcc -Wall -w test_sprites.c board.c buttons.c draw.c layouts.c tetromino.c GpuLib.o -o tetris -pthread -lintelfpgaup -std=c99
	sudo ./tetris

all:
	as -o GpuLib.o GpuLib.s
	gcc -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c GpuLib.o -o tetris -pthread -lintelfpgaup -std=c99
	sudo ./tetris
	
