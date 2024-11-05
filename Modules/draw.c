#include "prototype.h"

/**
 * Gera um caractere na tela nas coordenadas especificadas.
 *
 * Esta função desenha o caractere fornecido na posição indicada
 * pelas coordenadas `coordX` e `coordY`. A cor do caractere é
 * definida pelo parâmetro `color`.
 *
 * @param coordX  A coordenada x onde o caractere será desenhado.
 * @param coordY  A coordenada y onde o caractere será desenhado.
 * @param caracter O caractere a ser desenhado.
 * @param color    A cor do caractere a ser desenhado.
 */

void generateChar(int coordX, int coordY, char caracter, short color)
{

    switch (caracter)
    {

    case '^':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 1, coordX + 3, coordY + 8, color, 1);
        videoBox(coordX + 4, coordY + 2, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 6, coordY + 3, coordX + 7, coordY + 6, color, 1);
        videoBox(coordX + 8, coordY + 4, coordX + 9, coordY + 5, color, 1);

        break;

    case '<':

        videoBox(coordX + 2, coordY + 4, coordX + 3, coordY + 5, color, 1);
        videoBox(coordX + 4, coordY + 2, coordX + 5, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 6, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 6, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 6, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case '>':

        videoBox(coordX + 2, coordY, coordX + 3, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 3, coordY + 9, color, 1);
        videoBox(coordX + 4, coordY + 2, coordX + 5, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 6, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 6, coordY + 4, coordX + 7, coordY + 5, color, 1);

        break;

    case ':':

        videoBox(coordX + 2, coordY + 2, coordX + 3, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 3, coordY + 7, color, 1);

        break;

    case ';':

        videoBox(coordX + 2, coordY + 2, coordX + 3, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 3, coordY + 9, color, 1);

        break;

    case '0':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 5, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 7, color, 1);

        break;

    case '1':

        videoBox(coordX + 2, coordY, coordX + 3, coordY + 1, color, 1);
        videoBox(coordX + 4, coordY, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case '2':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 3, coordY + 7, color, 1);
        videoBox(coordX, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case '3':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX, coordY + 6, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case '4':

        videoBox(coordX, coordY, coordX + 1, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 9, color, 1);

        break;

    case '5':

        videoBox(coordX, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX, coordY + 2, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case '6':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case '7':

        videoBox(coordX, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 3, color, 1);
        videoBox(coordX + 6, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 4, coordY + 6, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 3, coordY + 9, color, 1);

        break;

    case '8':

        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX, coordY + 2, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX, coordY + 6, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case '9':

        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX, coordY + 2, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 7, color, 1);

        break;

    case 'a':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 9, color, 1);

        break;

    case 'b':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 3, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);

        break;

    case 'c':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case 'd':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 7, color, 1);

        break;

    case 'e':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case 'f':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);

        break;

    case 'g':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 9, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case 'h':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 9, color, 1);

        break;

    case 'i':

        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 4, coordY + 2, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case 'j':

        videoBox(coordX, coordY + 4, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 7, color, 1);

        break;

    case 'k':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 5, coordY + 5, color, 1);
        videoBox(coordX + 6, coordY + 2, coordX + 7, coordY + 3, color, 1);
        videoBox(coordX + 6, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 8, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case 'l':

        videoBox(coordX, coordY, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case 'm':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 2, coordX + 3, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 5, coordY + 5, color, 1);
        videoBox(coordX + 6, coordY + 2, coordX + 7, coordY + 3, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 9, color, 1);

        break;

    case 'n':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 2, coordX + 3, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 5, coordY + 5, color, 1);
        videoBox(coordX + 6, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 9, color, 1);

        break;

    case 'o':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 7, color, 1);

        break;

    case 'p':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 5, color, 1);

        break;

    case 'q':

        videoBox(coordX, coordY + 2, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 5, color, 1);
        videoBox(coordX + 6, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY + 8, coordX + 9, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 5, coordY + 9, color, 1);

        break;

    case 'r':

        videoBox(coordX, coordY, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY, coordX + 7, coordY + 1, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY + 2, coordX + 9, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    case 's':

        videoBox(coordX + 2, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX, coordY + 2, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case 't':

        videoBox(coordX, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 4, coordY + 2, coordX + 5, coordY + 9, color, 1);

        break;

    case 'u':

        videoBox(coordX, coordY, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 7, color, 1);

        break;

    case 'v':

        videoBox(coordX, coordY, coordX + 1, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 3, coordY + 7, color, 1);
        videoBox(coordX + 4, coordY + 8, coordX + 5, coordY + 9, color, 1);
        videoBox(coordX + 6, coordY + 6, coordX + 7, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 5, color, 1);

        break;

    case 'w':

        videoBox(coordX, coordY, coordX + 1, coordY + 7, color, 1);
        videoBox(coordX + 4, coordY + 2, coordX + 5, coordY + 7, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 7, color, 1);
        videoBox(coordX + 2, coordY + 8, coordX + 7, coordY + 9, color, 1);

        break;

    case 'x':

        videoBox(coordX, coordY, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX, coordY + 6, coordX + 1, coordY + 9, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 3, color, 1);
        videoBox(coordX + 8, coordY + 6, coordX + 9, coordY + 9, color, 1);

        break;

    case 'y':

        videoBox(coordX, coordY, coordX + 1, coordY + 3, color, 1);
        videoBox(coordX + 2, coordY + 4, coordX + 3, coordY + 5, color, 1);
        videoBox(coordX + 4, coordY + 6, coordX + 5, coordY + 9, color, 1);
        videoBox(coordX + 6, coordY + 4, coordX + 7, coordY + 5, color, 1);
        videoBox(coordX + 8, coordY, coordX + 9, coordY + 3, color, 1);

        break;

    case 'z':

        videoBox(coordX, coordY, coordX + 9, coordY + 1, color, 1);
        videoBox(coordX + 6, coordY + 2, coordX + 7, coordY + 3, color, 1);
        videoBox(coordX + 4, coordY + 4, coordX + 5, coordY + 5, color, 1);
        videoBox(coordX + 2, coordY + 6, coordX + 3, coordY + 7, color, 1);
        videoBox(coordX, coordY + 8, coordX + 9, coordY + 9, color, 1);

        break;

    default:

        break;
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

    colorRgb.red = (((colorHex >> 16) & 0xFF)*7)/255;
    colorRgb.green= (((colorHex >> 8) & 0xFF)*7)/255;
    colorRgb.blue = ((colorHex & 0xFF)*7)/255;
    
    return colorRgb;
}

void videoClear(){

    for (int i = 0; i < SCREEN_X/4; i++)
    {
        for (int j = 0; j < SCREEN_Y/4; j++)
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
    for (int i = initial_x/4; i < end_x/4; i++)
    {
        for (int j = initial_y/4; j < end_y/4; j++)
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
