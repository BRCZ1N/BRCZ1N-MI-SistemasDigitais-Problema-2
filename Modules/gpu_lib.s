

















.data 

DATA_A: @ Barramento “A” de dados do buffer de instrução.
      
      .word 0x80 

DATA_B: @ Barramento “B” de dados do buffer de instrução.
      
      .word 0x70 

RESET_PULSECOUNTER: @ Sinal que “reseta” o contador externo responsável por contar o tempo de renderização de uma tela.
                  
                  .word 0x90

SCREEN: @ Sinal que informa se o tempo derenderização de uma tela já foi finalizado.
      
      .word 0xa0

WRFULL: @ Sinal que informa se o buffer de instrução está cheio ou não.

      .word 0xb0

WRREG: @ Sinal de escrita do buffer de instrução.

     .word 0xc0
       


