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
        if (*pointerButtons == 14)
        {
            *pointerStateGame = 2;
        }
        break;

    case 2:
        if (*pointerButtons == 13)
        {
            *pointerStateGame = 1;
        }
        break;
    }
}
