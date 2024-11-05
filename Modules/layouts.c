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
    generateChar(2, 2, "A", COLOR_WHITE);

    drawScore(78, 2, score);

    // char text_highscore[7] = "hscore:";
    // generatePhrase(220, 2, text_highscore, 7, COLOR_WHITE);
    // drawScore(310, 2, hscore);
    //x,y 
    videoBox(110, 18, 112, 239, COLOR_BLUE, 1);  // LADO ESQUERDO
    videoBox(110, 234, 230, 239, COLOR_BLUE, 1); // CENTRO
    videoBox(225, 18, 230, 239, COLOR_BLUE, 1);  // Lado direito
}


#define CHAR_SIZE 5

unsigned short char_bitmaps[37][CHAR_SIZE][CHAR_SIZE] = {
    // A
    {
        {0,1,1,1,0},
        {1,0,0,0,1},
        {1,1,1,1,1},
        {1,0,0,0,1},
        {1,0,0,0,1}
    },
    // B
    {
        {1,1,1,1,0},
        {1,0,0,0,1},
        {1,1,1,1,0},
        {1,0,0,0,1},
        {1,1,1,1,0}
    },
    // C
    {
        {0,1,1,1,1},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {0,1,1,1,1}
    },
    // D
    {
        {1,1,1,1,0},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,0}
    },
    // E
    {
        {1,1,1,1,1},
        {1,0,0,0,0},
        {1,1,1,1,0},
        {1,0,0,0,0},
        {1,1,1,1,1}
    },
    // F
    {
        {1,1,1,1,1},
        {1,0,0,0,0},
        {1,1,1,1,0},
        {1,0,0,0,0},
        {1,0,0,0,0}
    },
    // G
    {
        {0,1,1,1,1},
        {1,0,0,0,0},
        {1,0,0,1,1},
        {1,0,0,0,1},
        {0,1,1,1,1}
    },
    // H
    {
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,1},
        {1,0,0,0,1},
        {1,0,0,0,1}
    },
    // I
    {
        {1,1,1,1,1},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {1,1,1,1,1}
    },
    // J
    {
        {0,1,1,1,1},
        {0,0,0,0,1},
        {0,0,0,0,1},
        {1,0,0,0,1},
        {0,1,1,1,0}
    },
    // K
    {
        {1,0,0,0,1},
        {1,0,0,1,0},
        {1,1,1,0,0},
        {1,0,0,1,0},
        {1,0,0,0,1}
    },
    // L
    {
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,1,1,1,1}
    },
    // M
    {
        {1,0,0,0,1},
        {1,1,0,1,1},
        {1,0,1,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1}
    },
    // N
    {
        {1,0,0,0,1},
        {1,1,0,0,1},
        {1,0,1,0,1},
        {1,0,0,1,1},
        {1,0,0,0,1}
    },
    // O
    {
        {0,1,1,1,0},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {0,1,1,1,0}
    },
    // P
    {
        {1,1,1,1,0},
        {1,0,0,0,1},
        {1,1,1,1,0},
        {1,0,0,0,0},
        {1,0,0,0,0}
    },
    // Q
    {
        {0,1,1,1,0},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,1,0,1},
        {0,1,1,1,1}
    },
    // R
    {
        {1,1,1,1,0},
        {1,0,0,0,1},
        {1,1,1,1,0},
        {1,0,1,0,0},
        {1,0,0,1,0}
    },
    // S
    {
        {0,1,1,1,1},
        {1,0,0,0,0},
        {0,1,1,1,0},
        {0,0,0,0,1},
        {1,1,1,1,0}
    },
    // T
    {
        {1,1,1,1,1},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0}
    },
    // U
    {
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {0,1,1,1,0}
    },
    // V
    {
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {0,1,0,1,0},
        {0,0,1,0,0}
    },
    // W
    {
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,1,0,1},
        {1,1,0,1,1},
        {1,0,0,0,1}
    },
    // X
    {
        {1,0,0,0,1},
        {0,1,0,1,0},
        {0,0,1,0,0},
        {0,1,0,1,0},
        {1,0,0,0,1}
    },
    // Y
    {
        {1,0,0,0,1},
        {0,1,0,1,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0}
    },
    // Z
    {
        {1,1,1,1,1},
        {0,0,0,1,0},
        {0,0,1,0,0},
        {0,1,0,0,0},
        {1,1,1,1,1}
    },
    // 0
    {
        {0,1,1,1,0},
        {1,0,0,0,1},
        {1,0,1,0,1},
        {1,0,0,0,1},
        {0,1,1,1,0}
    },
    // 1
    {
        {0,0,1,0,0},
        {0,1,1,0,0},
        {1,0,1,0,0},
        {0,0,1,0,0},
        {1,1,1,1,1}
    },
    // 2
    {
        {1,1,1,1,0},
        {0,0,0,0,1},
        {0,1,1,1,0},
        {1,0,0,0,0},
        {1,1,1,1,1}
    },
    // 3
    {
        {1,1,1,1,0},
        {0,0,0,0,1},
        {0,1,1,1,0},
        {0,0,0,0,1},
        {1,1,1,1,0}
    },
    // 4
    {
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,1},
        {0,0,0,0,1},
        {0,0,0,0,1}
    },
    // 5
    {
        {1,1,1,1,1},
        {1,0,0,0,0},
        {1,1,1,1,0},
        {0,0,0,0,1},
        {1,1,1,1,0}
    },
    // 6
    {
        {0,1,1,1,1},
        {1,0,0,0,0},
        {1,1,1,1,0},
        {1,0,0,0,1},
        {0,1,1,1,0}
    },
    // 7
    {
        {1,1,1,1,1},
        {0,0,0,0,1},
        {0,0,0,1,0},
        {0,0,1,0,0},
        {0,1,0,0,0}
    },
    // 8
    {
        {0,1,1,1,0},
        {1,0,0,0,1},
        {0,1,1,1,0},
        {1,0,0,0,1},
        {0,1,1,1,0}
    },
    // 9
    {
        {0,1,1,1,0},
        {1,0,0,0,1},
        {0,1,1,1,1},
        {0,0,0,0,1},
        {1,1,1,1,0}
    },
    // :
    {
    {0,0,0,0,0},
    {0,0,1,0,0},
    {0,0,0,0,0},
    {0,0,1,0,0},
    {0,0,0,0,0}
    }
};

// Função para imprimir um caractere
void generateChar(int coordX, int coordY, char caracter, short color) {
    int index = charToIndex(caracter);
    Color cor = convertHexToRgb(color);
    printf("\n"+ index);
    for (int i = 0; i < CHAR_SIZE; i++) {
        for (int j = 0; j < CHAR_SIZE; j++) {
            if (char_bitmaps[0][i][j] == 1)
                setBackgroundBlock(i, j, cor.red, cor.green, cor.blue);
        }
    }
}

// Função para mapear o caractere para o índice na matriz
int charToIndex(char c) {
    if (c >= 'A' && c <= 'Z') {
        return c - 'A';
    } else if (c >= '0' && c <= '9') {
        return c - '0' + 26;
    } else {
        return 36;  // Caractere inválido
    }
}
