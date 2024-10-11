#ifndef PROTOTYPE_H_INCLUDED
#define PROTOTYPE_H_INCLUDED

/*
 * prototype.h
 *
 * Este arquivo contém as declarações de funções e variáveis globais utilizadas no 
 * jogo Tetris. Inclui bibliotecas necessárias para manipulação de vídeo, 
 * controle de threads, e funções de suporte ao jogo.
 */

#include <intelfpgaup/video.h>
#include <intelfpgaup/KEY.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "constants.h"
#include "structs.h"
#include "acelerometro.h"
#include <unistd.h>

void execTetris();
int checkGameOver(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino); 
void generatePhrase(int coordX, int coordY, char *list, int lenList, short cor);
void drawScore(int coordX, int coordY, int score); 
void gameField(int score, int hscore); 
void generateChar(int coordX, int coordY, char caracter, short cor); 
void changeGameState(int *pointer_state, int *pointer_buttons); 
void initBoard(PartTetromino boardMatrix[LINES][COLUMNS]); 
int verifyCollision(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino); 
void fixTetromino(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino, int x, int y); 
void removeFullLines(PartTetromino boardMatrix[LINES][COLUMNS], int *score); 
void drawBoard(PartTetromino boardMatrix[LINES][COLUMNS]); 
void drawBoardTerminal(PartTetromino boardMatrix[LINES][COLUMNS]); 
void drawTetrominoTerminal(Tetromino tetromino); 
void moveTetromino(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino, int dx, int dy, int *moved); 
void generateQPattern(Tetromino *tetromino); 
void generateLPattern(Tetromino *tetromino); 
void generateIPattern(Tetromino *tetromino); 
void gerarIPatternRotate(Tetromino *tetromino); 
void generateTetromino(Tetromino *tetromino); 
void initTetromino(Tetromino *tetromino); 
void clearTetromino(PartTetromino boardMatrix[LINES][COLUMNS], Tetromino *tetromino); 
int buttonRead(); 
void changePauseState(int *pointerStateGame, int *pointerButtons); 

// Variáveis globais para o acelerômetro
extern int16_t axis_x; // Eixo X do acelerômetro.
extern pthread_mutex_t lock; // Mutex para controle de acesso a recursos compartilhados.

#endif
