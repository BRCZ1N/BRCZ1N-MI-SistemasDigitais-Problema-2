#include "prototype.h"
#include <fcntl.h>
#include <sys/mman.h>
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

#define KEYS_BASE 0x0
#define ALT_LWFPGASLVS_OFST 0xff200000
#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN 0x04000000

// Variáveis globais para o mapeamento e o arquivo de memória
int fd;
void *virtual_base;
volatile uint32_t *keys_ptr;

// Função para abrir e mapear a memória dos botões
int button_open() {
    // Abre o dispositivo de memória
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1) {
        printf("Erro ao abrir /dev/mem\n");
        return -1;
    }

    // Mapeia o endereço base
    virtual_base = mmap(NULL, HW_REGS_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, HW_REGS_BASE + ALT_LWFPGASLVS_OFST);
    if (virtual_base == MAP_FAILED) {
        printf("Erro no mmap\n");
        close(fd);
        return -1;
    }

    // Define o ponteiro para o endereço dos botões
    keys_ptr = (uint32_t *) (virtual_base + KEYS_BASE);
    return 0;
}

// Função para ler o estado dos botões
uint32_t button_read() {
    if (keys_ptr == NULL) {
        printf("Erro: ponteiro para os botões não inicializado\n");
        return -1;
    }
    return *keys_ptr;
}

// Função para fechar e liberar o mapeamento de memória
void button_close() {
    if (munmap(virtual_base, HW_REGS_SPAN) != 0) {
        printf("Erro ao desmapear\n");
    }
    close(fd);
}

// int main() {
//     // Abre o mapeamento de memória
//     if (button_open() != 0) {
//         return -1;
//     }

//     // Lê o valor dos botões
//     uint32_t button_value = button_read();
//     printf("Valor dos push buttons: 0x%x\n", button_value);

//     // Fecha e libera o mapeamento de memória
//     button_close();
    
//     return 0;
// }



/**
 * Altera o estado de pausa do jogo com base na entrada dos botões.
 *
 * Esta função verifica o estado atual do jogo e o valor dos botões pressionados. 
 * Se o jogo estiver em execução (estado 1) e o botão de pausa for pressionado 
 * (valor 2), o estado do jogo muda para pausado (estado 2). Se o jogo estiver 
 * pausado e o mesmo botão for pressionado, o estado volta para em execução. 
 * A função utiliza ponteiros para modificar os estados diretamente.
 *
 * @param pointerStateGame Ponteiro para o estado atual do jogo, que pode 
 *                         ser 1 (em execução) ou 2 (pausado).
 * @param pointerButtons Ponteiro que representa o valor dos botões 
 *                       pressionados, onde o valor 2 indica o botão de pausa.
 */

void changePauseState(int *pointerStateGame, int *pointerButtons)
{

    switch (*pointerStateGame)
    {
    case 1:
        if (*pointerButtons == 2)
        {
            *pointerStateGame = 2;
        }
        break;

    case 2:
        if (*pointerButtons == 2)
        {
            *pointerStateGame = 1;
        }
        break;
    }
}

/**
 * Lê o valor do botão pressionado.
 *
 * Esta função abre a interface de leitura dos botões, lê o valor atual do 
 * botão pressionado, e então fecha a interface. O valor lido é retornado 
 * pela função. Este processo permite a interação do usuário com o sistema 
 * através de botões, sendo útil para controlar ações no programa.
 *
 * @return int Valor lido dos botões, representando o botão que foi pressionado. 
 *              Um valor específico indica um botão específico.
 */

// int buttonRead()
// {

//     int readValue;

//     KEY_open();
//     KEY_read(&readValue);
//     KEY_close();

//     return readValue;
// }
