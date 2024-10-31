all:
	clear
	gcc -w -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c gpu.s -o tetris -pthread -lintelfpgaup -lm -std=c99
	sudo ./tetris