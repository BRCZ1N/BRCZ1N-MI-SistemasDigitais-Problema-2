#include "prototype.h"
int16_t axis_x;
pthread_mutex_t lock;





/*
     * Função principal que inicializa o ambiente do jogo Tetris.
     * Cria duas threads: 
     * - A primeira thread executa a função execAccel, que lida com a função principal de execução do acelerômetro.
     * - A segunda thread executa a função execTetris, que contém a lógica principal do jogo Tetris.
     * Um mutex é inicializado para garantir que o acesso a recursos compartilhados, como a variável axis_x, seja feito de maneira segura.
     * As threads são unidas ao final da execução, garantindo que o programa aguarde a conclusão de ambas antes de encerrar.
     */
int main()
{

    printf("Deu exec");
    pthread_t thread1, thread2;

    pthread_mutex_init(&lock, NULL);

    pthread_create(&thread1, NULL, execAccel, NULL);

    pthread_create(&thread2, NULL, execTetris, NULL);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    pthread_mutex_destroy(&lock);

    return 0;
}
/**
 * Função principal do jogo Tetris que controla a lógica do jogo.
 *
 * Esta função é executada em uma thread separada e gerencia o fluxo
 * do jogo Tetris, incluindo a inicialização do tabuleiro, controle
 * dos tetrominos, verificação de condições de jogo, e exibição
 * do estado do jogo na tela. O loop principal continua até que o
 * jogo esteja terminado, e ele permite alternar entre pausar e
 * retomar o jogo.
 *
 * @note A função utiliza variáveis globais para o controle do estado
 *       do jogo e acesso a recursos de vídeo.
 */
void execTetris()
{

    int state_game = 1, buttons, buttonValue, buttonValueRotate;
    int16_t mg_per_lsb = 4;

    srand(time(NULL));
    
    Tetromino currentTetromino;
    PartTetromino boardMatrix[LINES][COLUMNS];
    int dx = 0, dy = 1, moved = 1, score, hscore;
    char text_over[4] = "over";
    char text_paused[6] = "paused";
    char text_game[4] = "game";

    while (1)
    {
        gpuMapping();
        setBackgroundBlock(1,2,3,1,1);
        closeGpuMapping();

        score = 0;
        resetBoard(boardMatrix);
        initTetromino(&currentTetromino);
        int pointerStateGame = 1;

        while (!checkGameOver(boardMatrix, &currentTetromino))
        {
            buttonValue = buttonRead();

            changePauseState(&pointerStateGame, &buttonValue);

            if (pointerStateGame == 1)
            {

                pthread_mutex_lock(&lock);
                if (axis_x * mg_per_lsb >= 100)
                {

                    dx = 1;
                }
                else if (axis_x * mg_per_lsb <= -100)
                {

                    dx = -1;
                }
                else
                {

                    dx = 0;
                }
                pthread_mutex_unlock(&lock);
                moveTetromino(boardMatrix, &currentTetromino, dx, dy, &moved);
                dx = 0;
                if (!moved)
                {
                    removeFullLines(boardMatrix, &score);
                    initTetromino(&currentTetromino);
                }
                drawTetrominoTerminal(currentTetromino);
                gpuMapping();
                //();
                drawBoard(boardMatrix);

                closeGpuMapping();
                usleep(150000);
            }
            else
            {
                gpuMapping();
            
                //();
                drawBoard(boardMatrix);
        
                closeGpuMapping();
            }
            drawBoardTerminal(boardMatrix);
        }
        gpuMapping();

   
        drawBoard(boardMatrix);
        
        usleep(8000000);
        //();
        closeGpuMapping();
        if(score > hscore){

            hscore = score;

        }
    }
}
