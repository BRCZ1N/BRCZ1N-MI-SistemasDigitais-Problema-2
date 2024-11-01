all:
	as -o GpuLib.o GpuLib.s
	gcc -Wall -w test_sprites.c board.c buttons.c draw.c layouts.c tetromino.c GpuLib.o -o tetris -pthread -lintelfpgaup -std=c99
	sudo ./tetris

all:
	as -o GpuLib.o GpuLib.s
	gcc -Wall main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c GpuLib.o -o tetris -pthread -lintelfpgaup -std=c99
	sudo ./tetris


# Tem que testar esse makefile pra ver se o sudo executa direto sem problemas
# Nome do executável
EXEC = tetris

# Arquivos de código-fonte e objetos
SRC = main.c board.c acelerometro.c buttons.c draw.c layouts.c tetromino.c GpuLib.o
OBJ = $(SRC:.c=.o)

# Flags de compilação
CFLAGS = -Wall -pthread -lintelfpgaup -std=c99
AS = as
GCC = gcc

# Regra padrão 'all' para compilar o programa
all: $(EXEC)

$(EXEC): $(OBJ)
	$(GCC) $(CFLAGS) -o $(EXEC) $(OBJ)

GpuLib.o: GpuLib.s
	$(AS) -o GpuLib.o GpuLib.s

# Regra para limpar os arquivos objetos e executável
clean:
	rm -f $(OBJ) $(EXEC)

# Regra para executar o programa com sudo
run: all
	sudo ./$(EXEC)

	
