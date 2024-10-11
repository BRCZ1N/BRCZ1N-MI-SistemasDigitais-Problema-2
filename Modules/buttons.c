#include "prototype.h"

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

int buttonRead()
{

    int readValue;

    KEY_open();
    KEY_read(&readValue);
    KEY_close();

    return readValue;
}
