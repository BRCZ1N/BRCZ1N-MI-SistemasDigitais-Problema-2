#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

extern int gpu_init(void);
extern void gpu_exit(void);
extern void instruction_wbr(int r, int g, int b);
extern void instruction_wbr_sprite(int reg, int offset, int x, int y);
extern void instruction_wbm(int address, int r, int g, int b, int reg);
extern void instruction_wsm(int address, int r, int g, int b);
extern void instruction_dp(int address, int ref_x, int ref_y, int size, int r, int g, int b, int shape);

// all:
// 	clear
// 	gcc -w -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c gpu_lib.s -o tetris -pthread -lintelfpgaup -lm -std=c99
// 	sudo ./tetris


int main() {
    // Inicializa o driver GPU
    gpu_init();
    // Exemplo de uso das instruções
    // Chame suas instruções de acordo com a lógica que você deseja testar
    

    instruction_wbr_sprite(1, 2, 3, 4); // Testa a função WBM

    // Finaliza o driver GPU
    gpu_exit();

    return 0;
}
