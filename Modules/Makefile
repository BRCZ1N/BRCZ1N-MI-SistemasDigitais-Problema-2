all:
	clear
	gcc -g -o tetris test_sprites.c gpu_lib.s -lm -std=c99
	sudo ./tetris
	
run:
	clear
	as -o gpu_lib.o gpu_lib.s
	ld -o gpu_lib gpu_lib.o
	sudo ./gpu_lib
