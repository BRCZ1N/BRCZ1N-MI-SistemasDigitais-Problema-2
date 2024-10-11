all:
	clear
	gcc -w -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c gpu_lib.s mapping.s -o tetris -pthread -lintelfpgaup -lm -std=c99
	sudo ./tetris