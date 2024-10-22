all:
	clear
	gcc -g -fsanitize=address -o tetris test_sprites.c gpu_lib.s -lm -std=c99
	sudo ./tetris