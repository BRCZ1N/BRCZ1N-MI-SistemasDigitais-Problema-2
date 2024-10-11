.data

ALT_LWFPGASLVS_OFST: @ Armazena o endereço de offset do barramento "Lightweight HPS-to-FPGA AXI" em relação ao endereço base do HPS.

                   .word 0xFF200000

HW_REGS_BASE: @ Armazena o endereço base para os registradores de acesso aos periféricos do HPS.
       
            .word 0xFC000000

HW_REGS_SPAN: @ Armazena o comprimento em bytes da região de memória a ser mapeada.

            .word 0x04000000
