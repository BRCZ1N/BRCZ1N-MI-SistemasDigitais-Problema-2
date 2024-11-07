#include "acelerometro.h"
#include "mapa_endereco.h"
#include <stdio.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <pthread.h>
#include "prototype.h"

// Ponteiros para os registradores I2C0 e SYSMGR (Gerenciador de Sistema)
static unsigned int *ponteiro_base_i2c, *ponteiro_gerenciador;
static void *base_i2c_vitural, *gerenciador_base_virtual;
static int pasta_i2c = -1, pasta_gerenciador = -1;

/**
 * Executa a inicialização e operação contínua do acelerômetro via protocolo I2C.
 *
 * Esta função mapeia o espaço de memória para o gerenciador de sistema e o controlador I2C,
 * configura o multiplexador (MUX) para o uso do I2C, e inicializa o controlador I2C0. Em seguida,
 * verifica o ID do dispositivo acelerômetro e, se correto, realiza a calibração e monitora 
 * continuamente os dados do eixo X, atualizando-os conforme necessário. Se o ID do dispositivo 
 * estiver incorreto, a função imprime uma mensagem de erro.
 *
 * @param args Ponteiro para argumentos adicionais, embora não utilizado diretamente na implementação.
 */

void execAccel(void *args)
{

    uint8_t devid;
    int16_t sensibilidade = 4;

    // Abrir e mapear o endereço físico do SYSMGR
    if ((pasta_gerenciador = Abrir_memoria_fisica(pasta_gerenciador)) == -1)
    {
        return (-1);
    }

    if ((gerenciador_base_virtual = Mapear_memoria_fisica(pasta_gerenciador, SYSMGR_BASE, SYSMGR_SPAN)) == NULL)
    {
        return (-1);
    }

    ponteiro_gerenciador = (unsigned int *)gerenciador_base_virtual;

    // Abrir e mapear o endereço físico do I2C0
    if ((pasta_i2c = Abrir_memoria_fisica(pasta_i2c)) == -1)
    {
        return (-1);
    }

    if ((base_i2c_vitural = Mapear_memoria_fisica(pasta_i2c, I2C0_BASE, I2C0_SPAN)) == NULL)
    {
        return (-1);
    }

    ponteiro_base_i2c = (unsigned int *)base_i2c_vitural;

    // Configurar Mux para usar i2c
    Configurar_mux();
    printf("Mux Selecionado protocolo I2C\n");

    // Inicializar o Controlador I2C0
    Inicializar_I2C0();
    printf("Inicializando protocolo de comunicação I2C0\n");

    // 0xE5 é lido de DEVID(0x00) se o I2C estiver funcionando corretamente
    ler_REG(0x00, &devid);

    // Verificar ID do dispositivo
    if (devid == 0xE5)
    {
        printf("Foi inicializado corretamente\n");
        // Inicializar o acelerômetro
        iniciar_acelerometro();

        calibrar();

        while (1)
        {
            if (dados_atualizados())
            {
                pthread_mutex_lock(&lock);
                axis_x = ler_x();
                printf("Eixo X = %d mg\n", axis_x * sensibilidade);
                pthread_mutex_unlock(&lock);
            }
        }
    }
    else
    {
        printf("ID do dispositivo incorreto\n");
    }

    return 0;
}

/**
 * Configura o multiplexador de pinos (pin mux) para conectar o acelerômetro ao barramento I2C0.
 *
 * Esta função ajusta o gerenciador de sistema (sysmgr) para desabilitar o uso da interface FPGA 
 * para o I2C0 e configura os pinos de entrada/saída (GENERALIO7 e GENERALIO8) para funcionar como 
 * as linhas de dados (SDA) e clock (SCL) do barramento I2C0, respectivamente.
 */
void Configurar_mux()
{
    // Desabilita o uso da interface FPGA para I2C0
    *(ponteiro_gerenciador + SYSMGR_I2C0USEFPGA) = 0;
    // Configura GENERALIO7 para I2C0.SDA
    *(ponteiro_gerenciador + SYSMGR_GENERALIO7) = 1;
    // Configura GENERALIO8 para I2C0.SCL
    *(ponteiro_gerenciador + SYSMGR_GENERALIO8) = 1;
}

/**
 * Inicializa o controlador I2C0 para comunicação com o acelerômetro.
 *
 * Esta função configura o controlador I2C0 para atuar como mestre, com endereçamento de 7 bits 
 * e em modo rápido (400 kb/s). Ela aborta qualquer transmissão em andamento, configura o 
 * clock SCL de acordo com os requisitos de temporização e habilita o controlador para uso com 
 * o endereço do dispositivo alvo (0x53). A função também verifica o status de habilitação e espera 
 * até que o controlador esteja pronto.
 */

void Inicializar_I2C0()
{

    // Aborta qualquer transmissão em andamento e desabilita I2C0.
    *(ponteiro_base_i2c + I2C0_ENABLE) = 2;

    // Espera até que o I2C0 esteja desabilitado
    while (((*(ponteiro_base_i2c + I2C0_ENABLE_STATUS)) & 0x1) == 1)
    {
        // zona critica
    }

    // Configura o registrador de configuração com as configurações desejadas (atuar como
    // mestre, usa endereçamento de 7 bits, modo rápido (400kb/s)).
    *(ponteiro_base_i2c + I2C0_CON) = 0x65;

    // Define endereço alvo (desabilitar comandos especiais, usar endereçamento de 7 bits)
    *(ponteiro_base_i2c + I2C0_TAR) = 0x53;

    // Define contagens altas/baixas do SCL (Assumindo clock de entrada de 100MHz no Controlador I2C0).
    // O período mínimo alto do SCL é 0.6us, e o período mínimo baixo do SCL é 1.3us,
    // No entanto, o período combinado deve ser de 2.5us ou maior, então adiciona-se 0.3us a cada.
    *(ponteiro_base_i2c + I2C0_FS_SCL_HCNT) = 60 + 30;  // 0.6us + 0.3us
    *(ponteiro_base_i2c + I2C0_FS_SCL_LCNT) = 130 + 30; // 1.3us + 0.3us

    // Habilita o controlador
    *(ponteiro_base_i2c + I2C0_ENABLE) = 1;

    // Espera até que o controlador esteja habilitado
    while (((*(ponteiro_base_i2c + I2C0_ENABLE_STATUS)) & 0x1) == 0)
    {
        // zona critica
    }
}

/**
 * Lê o valor de um registrador do acelerômetro via protocolo I2C.
 *
 * Esta função envia o endereço do registrador a ser lido e emite um sinal de leitura 
 * através do controlador I2C0. Em seguida, espera até que o buffer de recepção (RX) 
 * contenha dados e armazena o valor lido no ponteiro fornecido.
 *
 * @param endereco Endereço do registrador a ser lido.
 * @param valor Ponteiro para armazenar o valor lido do registrador.
 */
void ler_REG(uint8_t endereco, uint8_t *valor)
{

    // Envia endereço do registrador (+0x400 para enviar sinal START)
    *(ponteiro_base_i2c + I2C0_DATA_CMD) = endereco + 0x400;

    // Envia sinal de leitura
    *(ponteiro_base_i2c + I2C0_DATA_CMD) = 0x100;

    // Ler a resposta (primeiro espera até que o buffer RX contenha dados)
    while (*(ponteiro_base_i2c + I2C0_RXFLR) == 0)
    {
        // zona critica
    }

    *valor = *(ponteiro_base_i2c + I2C0_DATA_CMD);
}

/**
 * Configura e inicia o acelerômetro.
 *
 * Esta função configura-o para operar com uma faixa de medição de ±16g 
 * e resolução total, define a taxa de dados de saída para 200Hz e habilita 
 * interrupções para detectar atividade e inatividade. Ela também configura 
 * os limiares e o tempo de inatividade. Por fim, a função para e inicia o 
 * modo de medição do acelerômetro.
 */
void iniciar_acelerometro()
{

    // Faixa de +- 16g, resolução total
    escreve_REG(ADXL345_REG_DATA_FORMAT, XL345_RANGE_16G | XL345_FULL_RESOLUTION);

    // Taxa de Dados de Saída: 200Hz
    escreve_REG(ADXL345_REG_BW_RATE, XL345_RATE_200);

    // Habilitando interrupções para atividade e inatividade
    escreve_REG(ADXL345_REG_THRESH_ACT, 0x04);                              // limiar de atividade
    escreve_REG(ADXL345_REG_THRESH_INACT, 0x02);                            // limiar de inatividade
    escreve_REG(ADXL345_REG_TIME_INACT, 0x02);                              // tempo para inatividade
    escreve_REG(ADXL345_REG_ACT_INACT_CTL, 0xFF);                           // Habilita acoplamento AC para limiares
    escreve_REG(ADXL345_REG_INT_ENABLE, XL345_ACTIVITY | XL345_INACTIVITY); // habilitar interrupções

    // Parar medição
    escreve_REG(ADXL345_REG_POWER_CTL, XL345_STANDBY);

    // Iniciar medição
    escreve_REG(ADXL345_REG_POWER_CTL, XL345_MEASURE);
}

/**
 * Realiza a calibração do acelerômetro.
 *
 * A função calibra o acelerômetro ao colocar o dispositivo em modo de espera, 
 * ler os offsets atuais e configurar o dispositivo para uma taxa de 100Hz e 
 * faixa de ±16g para realizar a medição. Ela coleta 32 amostras do eixo X, 
 * calcula a média das leituras e ajusta o valor de compensação do eixo X 
 * (offset) para garantir leituras precisas. Depois da calibração, a função 
 * restaura as configurações de taxa de dados e formato de dados originais e 
 * reinicia o modo de medição.
 */
void calibrar()
{

    int media = 0;
    int16_t X;
    int8_t compensacao;

    // Para medição
    escreve_REG(ADXL345_REG_POWER_CTL, XL345_STANDBY);

    // Obtém os offsets atuais
    ler_REG(ADXL345_REG_OFSX, (uint8_t *)&compensacao);

    // Usa taxa de 100 Hz para calibração. Salva a taxa atual.
    uint8_t taxa_salva;
    ler_REG(ADXL345_REG_BW_RATE, &taxa_salva);
    escreve_REG(ADXL345_REG_BW_RATE, XL345_RATE_100);

    // Usa faixa de 16g, resolução total. Salva o formato atual.
    uint8_t formato_de_dados_salvos;
    ler_REG(ADXL345_REG_DATA_FORMAT, &formato_de_dados_salvos);
    escreve_REG(ADXL345_REG_DATA_FORMAT, XL345_RANGE_16G | XL345_FULL_RESOLUTION);

    // Inicia medição
    escreve_REG(ADXL345_REG_POWER_CTL, XL345_MEASURE);

    // Obtém as médias das acelerações de x sobre 32 amostras (LSB 3.9 mg)
    int i = 0;
    while (i < 32)
    {
        if (dados_prontos())
        {
            X = ler_x();
            media += X;
            i++;
        }
    }

    media = Divisao_aproximada(media, 32);

    // Para medição
    escreve_REG(ADXL345_REG_POWER_CTL, XL345_STANDBY);

    // Calcula os offsets (LSB 15.6 mg)
    compensacao += Divisao_aproximada(0 - media, 4);

    // Define o registrador de offset X
    escreve_REG(ADXL345_REG_OFSX, compensacao);

    // Restaura a taxa de largura de banda original
    escreve_REG(ADXL345_REG_BW_RATE, taxa_salva);

    // Restaura o formato de dados original
    escreve_REG(ADXL345_REG_DATA_FORMAT, formato_de_dados_salvos);

    // Inicia medição
    escreve_REG(ADXL345_REG_POWER_CTL, XL345_MEASURE);
}

/**
 * Verifica se os dados do acelerômetro estão prontos para leitura.
 *
 * Esta função lê o registrador de fonte de interrupção (INT_SOURCE) do 
 * acelerômetro e verifica se a bandeira de dados prontos (DATAREADY) está 
 * definida. Se a bandeira estiver ativada, a função retorna verdadeiro, 
 * indicando que os dados estão disponíveis para leitura; caso contrário, 
 * retorna falso.
 *
 * @return true Se os dados estão prontos para leitura; false caso contrário.
 */

bool dados_prontos()
{
    bool pronto = falso;
    uint8_t dados;

    ler_REG(ADXL345_REG_INT_SOURCE, &dados);
    if (dados & XL345_DATAREADY)
        pronto = verdadeiro;

    return pronto;
}

/**
 * Verifica se há atualizações nos dados do acelerômetro.
 *
 * Esta função lê o registrador de fonte de interrupção (INT_SOURCE) do 
 * acelerômetro e verifica se a bandeira de atividade (ACTIVITY) está 
 * definida. Se a bandeira estiver ativada, a função retorna verdadeiro, 
 * indicando que os dados foram atualizados; caso contrário, retorna falso.
 *
 * @return true Se os dados foram atualizados; false caso contrário.
 */

bool dados_atualizados()
{
    bool pronto = falso;
    uint8_t data8;

    ler_REG(ADXL345_REG_INT_SOURCE, &data8);
    if (data8 & XL345_ACTIVITY)
        pronto = verdadeiro;

    return pronto;
}

/**
 * Lê os dados de aceleração do eixo X do acelerômetro.
 *
 * Esta função lê dois bytes do registrador de dados do eixo X e combina 
 * esses bytes para formar um valor de 16 bits representando a aceleração 
 * no eixo X. A leitura é feita a partir do registrador de dados, e caso 
 * ocorra um erro, o endereço do registrador pode ser substituído por 0x32.
 *
 * @return int16_t Valor da aceleração no eixo X.
 */
int16_t ler_x()
{
    uint8_t dados[2];
    int16_t axis_x;
    // se der erro nessa função trocar ADXL345_REG_DATAX0 por 0x32
    multileitura_REG(ADXL345_REG_DATAX0, dados, sizeof(dados));

    axis_x = (dados[1] << 8) | dados[0];
    return axis_x;
}

/**
 * Escreve um valor em um registrador interno do acelerômetro.
 *
 * Esta função envia o endereço do registrador especificado e o valor 
 * a ser escrito. O endereço é ajustado para incluir um sinal de início 
 * (START) ao enviar a informação.
 *
 * @param endereco Endereço do registrador a ser escrito.
 * @param valor Valor a ser escrito no registrador.
 */
void escreve_REG(uint8_t endereco, uint8_t valor)
{

    // Envia endereço do registrador (+0x400 para enviar sinal START)
    *(ponteiro_base_i2c + I2C0_DATA_CMD) = endereco + 0x400;

    // Envia valor
    *(ponteiro_base_i2c + I2C0_DATA_CMD) = valor;
}

/**
 * Lê múltiplos registradores internos consecutivos do acelerômetro.
 *
 * Esta função envia o endereço de um registrador e realiza leituras 
 * consecutivas, armazenando os valores em um array fornecido. O endereço 
 * é ajustado para incluir um sinal de início (START) e a função realiza 
 * a leitura "n" vezes, onde "n" é o tamanho especificado.
 *
 * @param endereco Endereço do registrador inicial para a leitura.
 * @param valores Array onde os dados lidos serão armazenados.
 * @param tamanho Número de registradores a serem lidos.
 */
void multileitura_REG(uint8_t endereco, uint8_t valores[], uint8_t tamanho)
{

    // Envia endereço do registrador (+0x400 para enviar sinal START)
    *(ponteiro_base_i2c + I2C0_DATA_CMD) = endereco + 0x400;

    // Envia sinal de leitura "n" vezes
    int i;
    for (i = 0; i < tamanho; i++)
        *(ponteiro_base_i2c + I2C0_DATA_CMD) = 0x100;

    // Ler os bytes
    int indice = 0;
    while (tamanho)
    {
        if ((*(ponteiro_base_i2c + I2C0_RXFLR)) > 0)
        {
            valores[indice] = *(ponteiro_base_i2c + I2C0_DATA_CMD);
            indice++;
            tamanho--;
        }
    }
}

/**
 * Abre o dispositivo de memória física /dev/mem para acesso a endereços físicos.
 *
 * Esta função tenta abrir o arquivo /dev/mem, se ainda não estiver aberto. 
 * Se a abertura falhar, uma mensagem de erro é impressa. O identificador do 
 * arquivo é retornado para uso em operações subsequentes.
 *
 * @param pasta_de_arquivo Identificador do arquivo para operações futuras.
 * @return int Identificador do arquivo aberto ou -1 em caso de erro.
 */
int Abrir_memoria_fisica(int pasta_de_arquivo)
{
    if (pasta_de_arquivo == -1)
        if ((pasta_de_arquivo = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
        {
            printf("ERRO: não foi possível abrir \"/dev/mem\"...\n");
            return (-1);
        }
    return pasta_de_arquivo;
}

/**
 * Fecha o dispositivo de memória física aberto para liberar acesso a endereços físicos.
 *
 * Esta função recebe o identificador do arquivo e o fecha, liberando 
 * recursos associados.
 *
 * @param pasta_de_arquivo Identificador do arquivo a ser fechado.
 */

void Fechar_memoria_fisica(int pasta_de_arquivo)
{
    close(pasta_de_arquivo);
}

/**
 * Mapeia endereços físicos para endereços virtuais.
 *
 * Esta função estabelece um mapeamento entre um endereço físico inicial 
 * e um tamanho especificado, retornando um ponteiro para a base do espaço 
 * mapeado. Se o mapeamento falhar, uma mensagem de erro é impressa, e 
 * NULL é retornado.
 *
 * @param pasta_de_arquivo Identificador do arquivo aberto para mapeamento.
 * @param base Endereço físico inicial para o mapeamento.
 * @param tamanho Tamanho do mapeamento em bytes.
 * @return void* Ponteiro para a base do espaço mapeado ou NULL em caso de erro.
 */

void *Mapear_memoria_fisica(int pasta_de_arquivo, unsigned int base, unsigned int tamanho)
{
    void *virtual_base;

    // Faz um mapeamento dos endereços físicos para endereços virtuais
    virtual_base = mmap(NULL, tamanho, (PROT_READ | PROT_WRITE), MAP_SHARED, pasta_de_arquivo, base);

    if (virtual_base == MAP_FAILED)
    {
        printf("ERRO: mmap() falhou...\n");
        close(pasta_de_arquivo);
        return (NULL);
    }
    return virtual_base;
}

/**
 * Fecha o mapeamento de endereço virtual previamente estabelecido.
 *
 * Esta função utiliza `munmap` para desfazer o mapeamento de um endereço virtual 
 * associado a um endereço físico. Se o `munmap` falhar, uma mensagem de erro é exibida.
 * 
 * @param virtual_base Ponteiro para o endereço virtual previamente mapeado.
 * @param tamanho Tamanho do mapeamento a ser desfeito, em bytes.
 * @return int Retorna 0 em caso de sucesso, ou -1 se o mapeamento falhar.
 */
int Desmapear_memoria_fisica(void *virtual_base, unsigned int tamanho)
{
    if (munmap(virtual_base, tamanho) != 0)
    {
        printf("ERRO: munmap() falhou...\n");
        return (-1);
    }
    return 0;
}
