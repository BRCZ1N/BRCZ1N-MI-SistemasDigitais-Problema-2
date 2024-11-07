#ifndef STRUCTS_H_INCLUDED
#define STRUCTS_H_INCLUDED

#include "prototype.h"

/*
 * Tetromino
 *
 * Estrutura que representa uma peça do jogo Tetris.
 *
 * Campos:
 *  - x: Posição X da peça no tabuleiro.
 *  - y: Posição Y da peça no tabuleiro.
 *  - currentRotation: Indica a rotação atual da peça (0 a 3).
 *  - pattern: Matriz 4x4 que define a forma da peça nas diferentes rotações.
 *  - color: Cor da peça (representada por um número inteiro).
 *  - generate: Ponteiro para função que define a geração do tetromino.
 */
typedef struct
{

    int x, y, currentRotation;
    int pattern[MAX_ROTATIONS][4][4];
    unsigned int color;
    void (*generate)(struct Tetromino *);

} Tetromino;

/*
 * PartTetromino
 *
 * Estrutura que representa uma parte do tabuleiro do jogo, indicando
 * se está ocupada por uma peça e qual a cor da peça presente.
 *
 * Campos:
 *  - isNotEmpty: Indica se a célula do tabuleiro está ocupada (1) ou vazia (0).
 *  - color: Cor da parte ocupada no tabuleiro (representada por um número inteiro).
 */
typedef struct
{

    int isNotEmpty;
    unsigned int color;

} PartTetromino;

typedef struct
{

    int red;
    int green;
    int blue;

} Color;

#endif
