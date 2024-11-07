#include "prototype.h"

/**
 * Redefine a matriz do tabuleiro do jogo para seu estado inicial.
 *
 * Esta função percorre cada célula da matriz `boardMatrix`, que representa
 * o tabuleiro de jogo, e redefine as propriedades de cada peça (PartTetromino) 
 * para indicar que estão vazias e com a cor padrão. 
 * O campo `isNotEmpty` é definido como 0 (falso) e a cor é definida como 
 * `COLOR_WHITE`.
 *
 * @param boardMatrix Matriz bidimensional representando o tabuleiro do jogo, 
 *                    onde cada célula contém uma peça do tipo PartTetromino.
 */

void resetBoard(PartTetromino boardMatrix[LINES][COLUMNS])
{
    for (int i = 0; i < LINES; i++)
    {
        for (int j = 0; j < COLUMNS; j++)
        {
            boardMatrix[i][j].isNotEmpty = 0;
            boardMatrix[i][j].color = 0;
        }
    }
}

/**
 * Verifica se o jogo terminou.
 *
 * Esta função verifica se o tetromino atual colidiu com as peças já fixadas
 * no tabuleiro. Se houver uma colisão e a posição vertical do tetromino (y) 
 * for igual a 0, significa que não há mais espaço para o tetromino entrar, 
 * indicando que o jogo acabou. A função retorna 1 se o jogo terminou e 0 
 * caso contrário.
 *
 * @param boardMatrix Matriz bidimensional representando o tabuleiro do jogo, 
 *                    onde cada célula contém uma peça do tipo PartTetromino.
 * @param tetromino Ponteiro para o tetromino atual que está em movimento.
 * @return int Retorna 1 se o jogo acabou, ou 0 se ainda está em andamento.
 */

int checkGameOver(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino)
{

    if (verifyCollision(boardMatrix, tetromino) && tetromino->y == 0)
        return 1;
    return 0;
}

/**
 * Verifica colisões entre o tetromino atual e o tabuleiro de jogo.
 *
 * Esta função percorre a matriz de padrões do tetromino para verificar se 
 * há sobreposição com as peças já fixadas no tabuleiro (boardMatrix). 
 * Se qualquer parte do tetromino estiver fora dos limites do tabuleiro ou
 * se colidir com uma peça existente (indicada por `isNotEmpty`), a função 
 * retorna 1, indicando uma colisão. Se não houver colisões, retorna 0.
 *
 * @param boardMatrix Matriz bidimensional representando o tabuleiro do jogo, 
 *                    onde cada célula contém uma peça do tipo PartTetromino.
 * @param tetromino Ponteiro para o tetromino atual que está sendo avaliado.
 * @return int Retorna 1 se houver colisão, ou 0 se não houver colisão.
 */

int verifyCollision(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino)
{
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (tetromino->pattern[tetromino->currentRotation][i][j] == 1)
            {
                int posX = tetromino->x + j;
                int posY = tetromino->y + i;

                if (posX < 0 || posX >= COLUMNS || posY < 0 || posY >= LINES || boardMatrix[posY][posX].isNotEmpty)
                {
                    return 1;
                }
            }
        }
    }

    return 0;
}

/**
 * Fixa o tetromino atual no tabuleiro de jogo.
 *
 * Esta função percorre a matriz de padrões do tetromino e, para cada posição 
 * que ocupa no tabuleiro, atualiza a matriz `boardMatrix` para marcar as 
 * células correspondentes como ocupadas. As células são definidas como não 
 * vazias (`isNotEmpty` = 1) e sua cor é atualizada para a cor do tetromino. 
 * A função garante que as posições calculadas estejam dentro dos limites do 
 * tabuleiro antes de fazer a atualização.
 *
 * @param boardMatrix Matriz bidimensional representando o tabuleiro do jogo, 
 *                    onde cada célula contém uma peça do tipo PartTetromino.
 * @param tetromino Ponteiro para o tetromino atual que está sendo fixado.
 * @param x Coordenada X onde o tetromino deve ser fixado no tabuleiro.
 * @param y Coordenada Y onde o tetromino deve ser fixado no tabuleiro.
 */

void fixTetromino(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino, int x, int y)
{

    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (tetromino->pattern[tetromino->currentRotation][i][j] == 1)
            {
                int posX = x + j;
                int posY = y + i;

                if (posX >= 0 && posY < LINES && posY >= 0 && posX < COLUMNS)
                {
                    boardMatrix[posY][posX].isNotEmpty = 1;
                    boardMatrix[posY][posX].color = tetromino->color;
    
                }
            }
        }
    }
}

/**
 * Limpa a representação do tetromino atual no tabuleiro de jogo.
 *
 * Esta função percorre a matriz de padrões do tetromino e, para cada posição 
 * que o tetromino ocupa no tabuleiro, atualiza a matriz `boardMatrix` para 
 * remover a ocupação dessas células. As células são definidas como vazias 
 * (`isNotEmpty` = 0) e sua cor é resetada para 0. A função verifica se as 
 * posições calculadas estão dentro dos limites do tabuleiro antes de fazer 
 * a atualização.
 *
 * @param boardMatrix Matriz bidimensional representando o tabuleiro do jogo, 
 *                    onde cada célula contém uma peça do tipo PartTetromino.
 * @param tetromino Ponteiro para o tetromino atual que deve ser limpo do 
 *                  tabuleiro.
 */

void clearTetromino(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino)
{
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (tetromino->pattern[tetromino->currentRotation][i][j] == 1)
            {
                int posX = tetromino->x + j;
                int posY = tetromino->y + i;

                if (posX >= 0 && posX < COLUMNS && posY >= 0 && posY < LINES)
                {
                    boardMatrix[posY][posX].isNotEmpty = 0;
                    boardMatrix[posY][posX].color = 0;
                }
            }
        }
    }
}

/**
 * Remove linhas completas do tabuleiro e atualiza a pontuação.
 *
 * Esta função verifica cada linha do tabuleiro representado pela matriz 
 * `boardMatrix`. Se uma linha estiver completamente preenchida (todas as 
 * células `isNotEmpty` são diferentes de 0), a linha é removida, e as linhas 
 * acima dela são deslocadas para baixo. A função também incrementa a pontuação 
 * (`score`) sempre que uma linha é removida. Após a remoção, a nova linha superior 
 * é redefinida para estar vazia.
 *
 * @param boardMatrix Matriz bidimensional representando o tabuleiro do jogo, 
 *                    onde cada célula contém uma peça do tipo PartTetromino.
 * @param score Ponteiro para a pontuação atual do jogo, que será incrementada 
 *              ao remover linhas completas.
 */

void removeFullLines(PartTetromino boardMatrix[LINES][COLUMNS], int *score)
{
    for (int i = 0; i < LINES; i++)
    {
        int fullLine = 1;
        for (int j = 0; j < COLUMNS; j++)
        {
            if (boardMatrix[i][j].isNotEmpty == 0)
            {
                fullLine = 0;
                break;
            }
        }

        if (fullLine)
        {
            *score += 1;
            for (int k = i; k > 0; k--)
            {
                for (int l = 0; l < COLUMNS; l++)
                {
                    boardMatrix[k][l] = boardMatrix[k - 1][l];
                }
            }
            for (int l = 0; l < COLUMNS; l++)
            {
                boardMatrix[0][l].isNotEmpty = 0;
                boardMatrix[0][l].color = COLOR_WHITE;
            }
        }
    }
    videoClear();
}
