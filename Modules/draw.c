#include "prototype.h"

#define CHAR_SIZE 5

unsigned short char_bitmaps[37][5][4] = {
    // A
    {
        {0, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1}},
    // B
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 0},
        {1, 0, 0, 1},
        {1, 1, 1, 1}},
    // C
    {
        {0, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {0, 1, 1, 1}},
    // D
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1}},
    // E
    {
        {1, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 1, 1, 0},
        {1, 0, 0, 0},
        {1, 1, 1, 1}},
    // F
    {
        {1, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 1, 1, 0},
        {1, 0, 0, 0},
        {1, 0, 0, 0}},
    // G
    {
        {0, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 0, 1, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 1}},
    // H
    {
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1}},
    // I
    {
        {1, 1, 1, 1},
        {0, 1, 1, 0},
        {0, 1, 1, 0},
        {0, 1, 1, 0},
        {1, 1, 1, 1}},
    // J
    {
        {0, 1, 1, 1},
        {0, 0, 0, 1},
        {0, 0, 0, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 1}},
    // K
    {
        {1, 0, 0, 1},
        {1, 0, 1, 0},
        {1, 1, 0, 0},
        {1, 0, 1, 0},
        {1, 0, 0, 1}},
    // L
    {
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {1, 1, 1, 1}},
    // M
    {
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1}},
    // N
    {
        {1, 0, 0, 1},
        {1, 1, 0, 1},
        {1, 0, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1}},
    // O
    {
        {0, 1, 1, 0},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 0}},
    // P
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 0, 0, 0}},
    // Q
    {
        {0, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 1, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 1}},
    // R
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 0, 1, 0},
        {1, 0, 0, 1}},
    // S
    {
        {0, 1, 1, 1},
        {1, 0, 0, 0},
        {0, 1, 1, 0},
        {0, 0, 0, 1},
        {1, 1, 1, 0}},
    // T
    {
        {1, 1, 1, 1},
        {0, 1, 1, 0},
        {0, 1, 1, 0},
        {0, 1, 1, 0},
        {0, 1, 1, 0}},
    // U
    {
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 0}},
    // V
    {
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 0},
        {0, 0, 1, 0}},
    // W
    {
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 1, 1},
        {1, 1, 0, 1},
        {1, 0, 0, 1}},
    // X
    {
        {1, 0, 0, 1},
        {0, 1, 1, 0},
        {0, 0, 1, 0},
        {0, 1, 1, 0},
        {1, 0, 0, 1}},
    // Y
    {
        {1, 0, 0, 1},
        {0, 1, 1, 0},
        {0, 0, 1, 0},
        {0, 0, 1, 0},
        {0, 0, 1, 0}},
    // Z
    {
        {1, 1, 1, 1},
        {0, 0, 1, 0},
        {0, 1, 0, 0},
        {1, 0, 0, 0},
        {1, 1, 1, 1}},
    // 0
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1}},
    // 1
    {
        {0, 0, 1, 0},
        {0, 1, 1, 0},
        {0, 0, 1, 0},
        {0, 0, 1, 0},
        {0, 1, 1, 1}},
    // 2
    {
        {1, 1, 1, 1},
        {0, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 1, 1, 1}},
    // 3
    {
        {1, 1, 1, 1},
        {0, 0, 0, 1},
        {0, 1, 1, 1},
        {0, 0, 0, 1},
        {1, 1, 1, 1}},
    // 4
    {
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {0, 0, 0, 1},
        {0, 0, 0, 1}},
    // 5
    {
        {1, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 1, 1, 1},
        {0, 0, 0, 1},
        {1, 1, 1, 1}},
    // 6
    {
        {1, 1, 1, 1},
        {1, 0, 0, 0},
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1}},
    // 7
    {
        {1, 1, 1, 1},
        {0, 0, 0, 1},
        {0, 0, 0, 1},
        {0, 0, 0, 1},
        {0, 0, 0, 1}},
    // 8
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1}},
    // 9
    {
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
        {0, 0, 0, 1},
        {1, 1, 1, 1}}};

// Função para imprimir um caractere
void printChar(int coordX, int coordY, char caracter, short color)
{
    int index = charToIndex(caracter);
    Color cor = convertHexToRgb(color);
    for (int i = 0; i < CHAR_SIZE; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (char_bitmaps[index][i][j] == 1)
                setBackgroundBlock(coordX + i, coordY + j, cor.red, cor.green, cor.blue);
        }
    }
}

// Função para mapear o caractere para o índice na matriz
int charToIndex(char c)
{
    if (c >= 'A' && c <= 'Z')
    {
        return c - 'A';
    }
    else if (c >= 'a' && c <= 'z')
    {
        return c - 'A';
    }
    else if (c >= '0' && c <= '9')
    {
        return c - '0' + 26;
    }
    else
    {
        return 36; // Caractere inválido
    }
}

/**
 * Desenha o tabuleiro na tela usando a matriz fornecida.
 *
 * Esta função itera sobre a matriz de tetrominos e desenha os blocos
 * correspondentes em suas posições no tabuleiro. Blocos que não estão vazios
 * são desenhados com a cor especificada.
 *
 * @param boardMatrix A matriz que representa o estado do tabuleiro, onde cada
 *                    elemento contém informações sobre o bloco, incluindo
 *                    sua cor e se está vazio ou não.
 */

void drawBoard(PartTetromino boardMatrix[LINES][COLUMNS])
{
    for (int i = 0; i < LINES; i++)
    {
        for (int j = 0; j < COLUMNS; j++)
        {
            if (boardMatrix[i][j].isNotEmpty)
            {

                int initialX1 = INITIAL_LIMIT_X + j * (BLOCK_SIZE);
                int initialY1 = INITIAL_LIMIT_Y + i * (BLOCK_SIZE);
                int finalX2 = initialX1 + BLOCK_SIZE;
                int finalY2 = initialY1 + BLOCK_SIZE;
                videoBox(initialX1, initialY1, finalX2, finalY2, boardMatrix[i][j].color, 1);
            }
        }
    }
}

void clearBoard(PartTetromino boardMatrix[LINES][COLUMNS])
{
    for (int i = 0; i < LINES; i++)
    {
        for (int j = 0; j < COLUMNS; j++)
        {
            if (boardMatrix[i][j].isNotEmpty)
            {

                int initialX1 = INITIAL_LIMIT_X + j * (BLOCK_SIZE);
                int initialY1 = INITIAL_LIMIT_Y + i * (BLOCK_SIZE);
                int finalX2 = initialX1 + BLOCK_SIZE;
                int finalY2 = initialY1 + BLOCK_SIZE;
                videoBox(initialX1, initialY1, finalX2, finalY2, 0, 1);
            }
        }
    }
}

void generateBox(int column, int line, int R, int G, int B, int length)
{

    for (int i = 0; i < length; i++)
    {
        for (int j = 0; j < length; j++)
        {
            setBackgroundBlock((column * length) + j, (line * length) + i, R, G, B);
        }
    }
}

Color convertHexToRgb(int colorHex)
{
    Color colorRgb;

    colorRgb.red = (((colorHex >> 16) & 0xFF) * 7) / 255;
    colorRgb.green = (((colorHex >> 8) & 0xFF) * 7) / 255;
    colorRgb.blue = ((colorHex & 0xFF) * 7) / 255;

    return colorRgb;
}

void videoClear()
{

    for (int i = 0; i < SCREEN_X / 4; i++)
    {
        for (int j = 0; j < SCREEN_Y / 4; j++)
        {
            while (1)
            {
                if (((isFull() / sizeof(int))) == 0)
                {
                    generateBox(j, i, 0, 0, 0, 1);
                    break;
                }
            }
        }
    }
}

void videoBox(int initial_x, int initial_y, int end_x, int end_y, int color, int blockLength)
{

    Color colorRGB = convertHexToRgb(color);
    for (int i = initial_x / 4; i < end_x / 4; i++)
    {
        for (int j = initial_y / 4; j < end_y / 4; j++)
        {
            while (1)
            {
                if (((isFull() / sizeof(int))) == 0)
                {
                    generateBox(j, i, colorRGB.red, colorRGB.green, colorRGB.blue, blockLength);
                    break;
                }
            }
        }
    }
}

/**
 * Desenha o tabuleiro no terminal para depuração.
 *
 * Esta função exibe o estado do tabuleiro representado pela matriz
 * `boardMatrix`. Cada linha do tabuleiro é numerada, e os blocos
 * preenchidos são representados por `#`, enquanto os espaços vazios
 * são representados por `.`.
 *
 * @param boardMatrix A matriz que representa o estado do tabuleiro.
 */
void drawBoardTerminal(PartTetromino boardMatrix[LINES][COLUMNS])
{
    for (int i = 0; i < LINES; i++)
    {
        printf("%.2d", i + 1);
        for (int j = 0; j < COLUMNS; j++)
        {
            if (boardMatrix[i][j].isNotEmpty != 0)
            {

                printf("# ");
            }
            else
            {

                printf(". ");
            }
        }
        printf("\n");
    }
}

/**
 * Desenha o padrão do tetromino no terminal para depuração.
 *
 * Esta função exibe o padrão atual do tetromino passado como
 * argumento, utilizando `#` para representar os blocos preenchidos
 * e `.` para os espaços vazios. O padrão é exibido de acordo com
 * a rotação atual do tetromino.
 *
 * @param tetromino O tetromino a ser desenhado.
 */
void drawTetrominoTerminal(Tetromino tetromino)
{

    printf("Padrao:\n");
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (tetromino.pattern[tetromino.currentRotation][i][j] != 0)
            {
                printf("# ");
            }
            else
            {
                printf(". ");
            }
        }
        printf("\n");
    }
}
