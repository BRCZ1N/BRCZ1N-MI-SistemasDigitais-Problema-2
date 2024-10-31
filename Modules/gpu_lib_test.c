#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdint.h>

/* Definição dos OPCODES das instruções */
#define WBR 0b00
#define WBM 0b10
#define WSM 0b01
#define DP  0b11

/* Endereço base de memórias */
#define DATA_A  0x80
#define DATA_B  0x70
#define START 0xc0
#define WRFULL 0xb0
#define LW_BRIDGE_BASE 0xFF200000 
#define LW_BRIDGE_SPAN 0x00005000 

/* Declaração de variáveis globais */
volatile uint32_t *START_PTR;
volatile uint32_t *WRFULL_PTR;
volatile uint32_t *DATA_A_PTR;
volatile uint32_t *DATA_B_PTR;
void *LW_virtual;


int gpu_init(void) {
    int fd;

    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1) {
        perror("Erro ao abrir /dev/mem");
        return -1;
    }

    LW_virtual = mmap(NULL, LW_BRIDGE_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LW_BRIDGE_BASE);
    if (LW_virtual == MAP_FAILED) {
        perror("Erro no mmap");
        close(fd);
        return -1;
    }

    close(fd);

    DATA_A_PTR = (volatile uint32_t *) (LW_virtual + DATA_A);
    DATA_B_PTR = (volatile uint32_t *) (LW_virtual + DATA_B);   
    START_PTR = (volatile uint32_t *) (LW_virtual + START);
    WRFULL_PTR = (volatile uint32_t *) (LW_virtual + WRFULL);
    
    return 0;
}


void gpu_exit(void) {
    
    if (munmap(LW_virtual, LW_BRIDGE_SPAN) == -1) {
        perror("Erro ao desfazer mmap");
    }
}


void send_instruction(volatile uint32_t opcode_enderecamentos, volatile uint32_t dados) {
    /* Envia a instrução para a GPU via memória mapeada */
    *START_PTR = 0;  /* Desabilita o sinal de start */
    *DATA_A_PTR = opcode_enderecamentos;  /* Envia o OPCODE e o endereçamento */
    *DATA_B_PTR = dados;  /* Envia os dados */
    *START_PTR = 1;  /* Habilita o sinal de start */
    *START_PTR = 0;  /* Desabilita o sinal de start */
}


void instrucao_wbr(int r, int g, int b) {
    volatile uint32_t opcode = WBR;
    volatile uint32_t dados = (b << 6) | (g << 3) | r;
    send_instruction(opcode, dados);
}

void instrucao_wbr_sprite(int reg, int offset, int x, int y, int sp) {
    volatile uint32_t opcode = WBR;
    volatile uint32_t opcode_reg = (reg << 4) | opcode;
    volatile uint32_t dados = offset | (y << 9) | (x << 19);
    if (sp) {
        dados |= (1 << 29);
    }
    send_instruction(opcode_reg, dados);
}


void instrucao_wbm(int address, int r, int g, int b) {
    volatile uint32_t opcode = WBM;
    volatile uint32_t dados = (b << 6) | (g << 3) | r;
    volatile uint32_t opcode_reg = (address << 4) | opcode;
    send_instruction(opcode_reg, dados);
}

void instrucao_wsm(int address, int r, int g, int b) {
    volatile uint32_t opcode = WSM;
    volatile uint32_t dados = (b << 6) | (g << 3) | r;
    volatile uint32_t opcode_reg = (address << 4) | opcode;
    send_instruction(opcode_reg, dados);
}

void instrucao_dp(int address, int ref_x, int ref_y, int size, int r, int g, int b, int shape) {
    volatile uint32_t opcode = DP;
    volatile uint32_t opcode_reg = (address << 4) | opcode;
    volatile uint32_t rgb = (b << 6) | (g << 3) | r;
    volatile uint32_t dados = (rgb << 22) | (size << 18) | (ref_y << 9) | ref_x;
    if (shape) {
        dados |= (1 << 31);
    }
    send_instruction(opcode_reg, dados);
}
