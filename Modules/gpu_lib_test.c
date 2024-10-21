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

/**
 * Inicializa a comunicação com a GPU.
 *
 * Esta função realiza a abertura do arquivo especial `/dev/mem` e mapeia 
 * uma região da memória física para o espaço de usuário, permitindo a 
 * comunicação com o hardware da GPU.
 *
 * @return Retorna 0 se bem-sucedido, ou um valor negativo em caso de erro.
 */
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

/**
 * Encerra a comunicação com a GPU.
 *
 * Esta função desfaz o mapeamento da memória física, liberando os recursos
 * utilizados.
 */
void gpu_exit(void) {
    
    if (munmap(LW_virtual, LW_BRIDGE_SPAN) == -1) {
        perror("Erro ao desfazer mmap");
    }
}

/**
 * Envia uma instrução para a GPU.
 * 
 * Esta função envia uma instrução para a GPU, utilizando os endereçamentos
 * mapeados na memória. O envio é realizado através do registro START, com
 * os dados sendo enviados pelos registradores DATA_A e DATA_B.
 *
 * @param opcode_enderecamentos Opcode e endereçamento da instrução.
 * @param dados Dados da instrução.
 */
void send_instruction(volatile uint32_t opcode_enderecamentos, volatile uint32_t dados) {
    /* Envia a instrução para a GPU via memória mapeada */
    *START_PTR = 0;  /* Desabilita o sinal de start */
    *DATA_A_PTR = opcode_enderecamentos;  /* Envia o OPCODE e o endereçamento */
    *DATA_B_PTR = dados;  /* Envia os dados */
    *START_PTR = 1;  /* Habilita o sinal de start */
    *START_PTR = 0;  /* Desabilita o sinal de start */
}

/**
 * Monta e envia uma instrução WBR (alteração de cor do fundo).
 *
 * Esta função configura a cor do fundo enviando os valores RGB da cor para a GPU
 * via a instrução WBR (Write Background Register).
 *
 * @param r Componente vermelho da cor.
 * @param g Componente verde da cor.
 * @param b Componente azul da cor.
 */
void instrucao_wbr(int r, int g, int b) {
    volatile uint32_t opcode = WBR;
    volatile uint32_t dados = (b << 6) | (g << 3) | r;
    send_instruction(opcode, dados);
}

/**
 * Envia instrução WBR para sprite.
 *
 * Esta função configura um sprite, enviando o registro e offset, assim como as
 * coordenadas x e y do sprite, para a GPU.
 *
 * @param reg Registro a ser utilizado.
 * @param offset Offset da posição do sprite.
 * @param x Posição horizontal do sprite.
 * @param y Posição vertical do sprite.
 * @param sp Sinalizador para habilitar o sprite.
 */
void instrucao_wbr_sprite(int reg, int offset, int x, int y, int sp) {
    volatile uint32_t opcode = WBR;
    volatile uint32_t opcode_reg = (reg << 4) | opcode;
    volatile uint32_t dados = offset | (y << 9) | (x << 19);
    if (sp) {
        dados |= (1 << 29);
    }
    send_instruction(opcode_reg, dados);
}

/**
 * Envia instrução WBM (alteração de cor de blocos de fundo).
 *
 * Esta função altera a cor de blocos de fundo, enviando os valores RGB e o endereço
 * para a GPU via a instrução WBM.
 *
 * @param address Endereço de memória do bloco.
 * @param r Componente vermelho da cor.
 * @param g Componente verde da cor.
 * @param b Componente azul da cor.
 */
void instrucao_wbm(int address, int r, int g, int b) {
    volatile uint32_t opcode = WBM;
    volatile uint32_t dados = (b << 6) | (g << 3) | r;
    volatile uint32_t opcode_reg = (address << 4) | opcode;
    send_instruction(opcode_reg, dados);
}

/**
 * Envia instrução WSM (alteração de cor de pixels de sprite).
 *
 * Esta função altera a cor de pixels de sprites enviando os valores RGB e o endereço
 * para a GPU via a instrução WSM.
 *
 * @param address Endereço de memória do sprite.
 * @param r Componente vermelho da cor.
 * @param g Componente verde da cor.
 * @param b Componente azul da cor.
 */
void instrucao_wsm(int address, int r, int g, int b) {
    volatile uint32_t opcode = WSM;
    volatile uint32_t dados = (b << 6) | (g << 3) | r;
    volatile uint32_t opcode_reg = (address << 4) | opcode;
    send_instruction(opcode_reg, dados);
}

/**
 * Envia instrução DP (desenhar polígono).
 *
 * Esta função desenha um polígono na tela utilizando as coordenadas de referência,
 * tamanho, cor e formato do polígono, enviando-os para a GPU via a instrução DP.
 *
 * @param address Endereço de memória do polígono.
 * @param ref_x Coordenada X de referência.
 * @param ref_y Coordenada Y de referência.
 * @param size Tamanho do polígono.
 * @param r Componente vermelho da cor.
 * @param g Componente verde da cor.
 * @param b Componente azul da cor.
 * @param shape Formato do polígono (1 = preenchido, 0 = contorno).
 */
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
