#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

#define LW_BRIDGE_BASE 0x00000000
#define LW_BRIDGE_SPAN 0x00000010
#define DEV_MEM_PATH "/dev/mem"

extern int gpu_init(void);
extern void gpu_exit(void);
extern void instrucao_wbr(uint32_t r);
extern void instrucao_wbm(uint32_t address, uint32_t r, uint32_t g, uint32_t b);
extern void instrucao_wsm(uint32_t address, uint32_t r, uint32_t g, uint32_t b);
extern void instrucao_dp(uint32_t address, uint32_t ref_x, uint32_t ref_y, uint32_t size, uint32_t r, uint32_t g, uint32_t b);

static volatile uint32_t* LW_virtual;

// all:
// 	clear
// 	gcc -w -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c gpu_lib.s -o tetris -pthread -lintelfpgaup -lm -std=c99
// 	sudo ./tetris


int main() {
    // Inicializa o driver GPU
    if (gpu_init() < 0) {
        perror("Falha ao inicializar GPU");
        return -1;
    }

    // Exemplo de uso das instruções
    // Chame suas instruções de acordo com a lógica que você deseja testar
    uint32_t r = 0x1F; // Exemplo de valor para R
    instrucao_wbr(r);  // Testa a função WBR

    uint32_t address = 0x10; // Exemplo de endereço
    instrucao_wbm(address, 0x1F, 0x2F, 0x3F); // Testa a função WBM

    // Aqui você pode adicionar chamadas para instrucao_wsm e instrucao_dp conforme necessário

    // Finaliza o driver GPU
    gpu_exit();

    return 0;
}
