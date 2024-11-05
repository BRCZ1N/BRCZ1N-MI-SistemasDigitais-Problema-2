#ifndef CONSTANTS_H_INCLUDED
#define CONSTANTS_H_INCLUDED

#define SCREEN_X 320
#define SCREEN_Y 240
#define LINES 27
#define COLUMNS 14
#define BLOCK_SIZE 8
#define MAX_ROTATIONS 4
#define INITIAL_LIMIT_X 112
#define FINAL_LIMIT_X 212
#define INITIAL_LIMIT_Y 18
#define SPACING 2
#define SHADOW_OFFSET 2
#define CHAR_SIZE_LINE 5
#define CHAR_SIZE_COLUMN 3
#define QTD_CHAR 37

#define COLOR_WHITE 0xFFFFFF
#define COLOR_RED 0xFF0000
#define COLOR_GREEN 0x00FF00
#define COLOR_BLUE 0x0000FF
#define COLOR_YELLOW 0xFFFF00
#define COLOR_CYAN 0x00FFFF
#define COLOR_BLACK 0x000000
#define COLOR_PINK 0xFF00FF

typedef enum
{
    TETROMINO_Q = 0,
    TETROMINO_L = 1,
    TETROMINO_I = 2,
    TETROMINO_T = 3,
} TetrominoTipo;

#endif
