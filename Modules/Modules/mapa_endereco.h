#define I2C0_BASE 0xFFC04000          // base
#define I2C0_CON 0x00000000           // word offset
#define I2C0_TAR 0x00000001           // word offset
#define I2C0_DATA_CMD 0x00000004      // word offset
#define I2C0_FS_SCL_HCNT 0x00000007   // word offset
#define I2C0_FS_SCL_LCNT 0x00000008   // word offset
#define I2C0_ENABLE 0x0000001B        // word offset
#define I2C0_RXFLR 0x0000001E         // word offset
#define I2C0_ENABLE_STATUS 0x00000027 // word offset
#define I2C0_SPAN 0x00000100          // intervalo

#define SYSMGR_BASE 0xFFD08000        // base
#define SYSMGR_GENERALIO7 0x00000127  // 1 : O pino está conectado ao sinal do periférico I2C0.SDA.
#define SYSMGR_GENERALIO8 0x00000128  // 1: O pino está conectado ao sinal do periférico I2C0.SCL.
#define SYSMGR_I2C0USEFPGA 0x000001C1 // 0: I2C0 usa os pinos do HPS.
#define SYSMGR_SPAN 0x00000800        // base
