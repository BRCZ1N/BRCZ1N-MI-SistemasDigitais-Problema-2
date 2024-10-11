#ifndef ACELEROMETRO_H_
#define ACELEROMETRO_H_

#include <stdint.h>

typedef int bool;
#define verdadeiro 1
#define falso 0

// Registros do Controlador I2C0
#define I2C0_BASE ((volatile unsigned int *)0xFFC04000)
#define I2C0_CON ((volatile unsigned int *)0xFFC04000)           // Registro de Controle
#define I2C0_TAR ((volatile unsigned int *)0xFFC04004)           // Registro de endereço de destino
#define I2C0_DATA_CMD ((volatile unsigned int *)0xFFC04010)      // Registro de dados e comando
#define I2C0_FS_SCL_HCNT ((volatile unsigned int *)0xFFC0401C)   // Registro de contagem alta SCL (velocidade rápida)
#define I2C0_FS_SCL_LCNT ((volatile unsigned int *)0xFFC04020)   // Registro de contagem baixa SCL (velocidade rápida)
#define I2C0_ENABLE ((volatile unsigned int *)0xFFC0406C)        // Registro de nível FIFO de transmissão
#define I2C0_RXFLR ((volatile unsigned int *)0xFFC04078)         // Registro de nível FIFO de recepção
#define I2C0_ENABLE_STATUS ((volatile unsigned int *)0xFFC0409C) // Habilitar Registro de Status
#define I2C0_SPAN ((volatile unsigned int *)0x00000100)          // intervalo

// Registros de multiplexação de Pinos SYSMGR
#define SYSMGR_GENERALIO7 ((volatile unsigned int *)0xFFD0849C)  // 1 : O pino está conectado ao sinal do periférico I2C0.SDA.
#define SYSMGR_GENERALIO8 ((volatile unsigned int *)0xFFD084A0)  // 1 : O pino está conectado ao sinal do periférico I2C0.SCL.
#define SYSMGR_I2C0USEFPGA ((volatile unsigned int *)0xFFD08704) // 0 : I2C0 usa os pinos do HPS.
#define SYSMGR_BASE ((volatile unsigned int *)0xFFD08000)
#define SYSMGR_SPAN ((volatile unsigned int *)0x00000800)

// Lista de Registradores do ADXL345
#define ADXL345_REG_DATA_FORMAT 0x31
#define XL345_DATAREADY 0x80
#define XL345_RANGE_16G 0x03
#define ADXL345_REG_THRESH_ACT 0x24
#define XL345_FULL_RESOLUTION 0x08
#define ADXL345_REG_BW_RATE 0x2C
#define XL345_RATE_200 0x0b
#define ADXL345_REG_THRESH_INACT 0x25
#define ADXL345_REG_TIME_INACT 0x26
#define ADXL345_REG_ACT_INACT_CTL 0x27
#define ADXL345_REG_INT_ENABLE 0x2E // valor padrão: 0x00
#define XL345_INACTIVITY 0x08
#define XL345_ACTIVITY 0x10
#define ADXL345_REG_POWER_CTL 0x2D
#define XL345_STANDBY 0x00
#define XL345_MEASURE 0x08
#define ADXL345_REG_OFSX 0x1E
#define XL345_RATE_100 0x0a
#define ADXL345_REG_INT_SOURCE 0x30 // valor padrão: 0x02
#define ADXL345_REG_DATAX0 0x32     // apenas leitura
#define ADXL345_REG_DATAX1 0x33     // apenas leitura

// Macro de divisão arredondada
#define Divisao_aproximada(n, d) (((n < 0) ^ (d < 0)) ? ((n - d / 2) / d) : ((n + d / 2) / d))

// Funções do acelerometro
void execAccel(void *args);
void iniciar_acelerometro();
void calibrar();
bool dados_prontos();
bool dados_atualizados();
int16_t ler_x();
void ler_REG(uint8_t address, uint8_t *value);
void escreve_REG(uint8_t endereco, uint8_t valor);
void multileitura_REG(uint8_t endereco, uint8_t valores[], uint8_t tamanho);

// Funções I2C0
void Inicializar_I2C0();

// Funções de nmux
void Configurar_mux();

/* Protótipos das funções usadas para acessar endereços de memória física */
int Abrir_memoria_fisica(int);
void *Mapear_memoria_fisica(int, unsigned int, unsigned int);
void Fechar_memoria_fisica(int);
int Desmapear_memoria_fisica(void *, unsigned int);

#endif /*ACELEROMETRO*/
