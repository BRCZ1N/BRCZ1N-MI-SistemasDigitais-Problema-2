#include "prototype.h"

/**
 * Gera uma frase na tela com caracteres individuais.
 * 
 * Esta função itera sobre uma lista de caracteres e chama a função
 * `generateChar` para desenhar cada caractere em uma posição especificada.
 * Os caracteres são espaçados uniformemente, e os espaços são ignorados
 * durante o processo de geração.
 *
 * @param coordX A coordenada X inicial onde a frase será desenhada.
 * @param coordY A coordenada Y onde a frase será desenhada.
 * @param list A lista de caracteres que compõem a frase.
 * @param lenList O comprimento da lista de caracteres.
 * @param color A cor a ser usada para desenhar os caracteres.
 */
void generatePhrase(int coordX, int coordY, char *list, int lenList, short color)
{

    int X;

    for (int i = 0; i < lenList; ++i)
    {

        if (list[i] != ' ')
        {

            X = coordX + i * 13;
            generateChar(X, coordY, list[i], color);
        }
    }
}

/**
 * Desenha a pontuação na tela utilizando a função `generateChar`.
 * 
 * Esta função converte um número inteiro representando a pontuação
 * em uma string e desenha cada dígito na tela usando a função
 * `generateChar`. Os caracteres são espaçados uniformemente, cada um
 * ocupando uma posição específica baseada em coordenadas.
 *
 * @param coordX A coordenada X inicial onde a pontuação será desenhada.
 * @param coordY A coordenada Y onde a pontuação será desenhada.
 * @param score O valor da pontuação a ser exibida na tela, representado
 *              como um inteiro. Cada dígito será desenhado como um
 *              caractere colorido na tela.
 */
void drawScore(int coordX, int coordY, int score)
{

    char number_str[10];

    sprintf(number_str, "%d", score);

    int len = strlen(number_str);

    for (int i = 0; i < len; i++)
    {
        generateChar(coordX + (13 * i), coordY, number_str[i], COLOR_YELLOW);
    }
}

/**
 * Desenha o campo de jogo exibindo a pontuação atual e a pontuação máxima.
 *
 * Esta função utiliza a função `generatePhrase` para exibir o texto
 * "score:" e "hscore:", seguido pelos valores atuais de pontuação
 * e a maior pontuação (high score). As pontuações são desenhadas
 * na tela em posições específicas, e bordas são desenhadas usando
 * a função `videoBox` para delimitar o campo de jogo.
 *
 * @param score A pontuação atual do jogador, que será exibida na tela.
 * @param hscore A maior pontuação registrada, que será exibida ao lado
 *               da pontuação atual.
 */
void gameField(int score, int hscore)
{

    char text_score[6] = "score:";
    generatePhrase(2, 2, text_score, 6, COLOR_WHITE);
    drawScore(78, 2, score);

    char text_highscore[7] = "hscore:";
    generatePhrase(220, 2, text_highscore, 7, COLOR_WHITE);
    drawScore(310, 2, hscore);

    videoBox(105, 18, 110, 239, COLOR_BLUE, 4);  // LADO ESQUERDO
    videoBox(106, 234, 212, 239, COLOR_BLUE, 4); // CENTRO
    videoBox(210, 18, 215, 239, COLOR_BLUE, 4);  // Lado direito
}