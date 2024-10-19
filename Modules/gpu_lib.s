        .section .data
WBR:            .word 0b00              @ Código de operação WBR
WBM:            .word 0b10              @ Código de operação WBM
WSM:            .word 0b01              @ Código de operação WSM
DP:             .word 0b11              @ Código de operação DP

        .section .text
        .global gpu_init
        .global gpu_exit
        .global send_instruction
        .global instrucao_wbr
        .global instrucao_wbr_sprite
        .global instrucao_wbm
        .global instrucao_wsm
        .global instrucao_dp

gpu_init:
        LDR     r0, ="/dev/mem"         @ Carrega o caminho do arquivo
        MOV     r1, #0                   @ O_RDWR | O_SYNC
        BL      open                     @ Abre /dev/mem
        CMP     r0, #0                   @ Verifica se fd é -1
        BEQ     .error_open              @ Se sim, vai para erro
        LDR     r1, =LW_BRIDGE_BASE      @ Endereço base da memória
        LDR     r2, =LW_BRIDGE_SPAN      @ Tamanho da memória
        MOV     r3, #3                   @ PROT_READ | PROT_WRITE
        MOV     r4, #1                   @ MAP_SHARED
        BL      mmap                     @ Faz o mapeamento
        CMP     r0, #0                   @ Verifica se LW_virtual é MAP_FAILED
        BEQ     .error_mmap              @ Se sim, vai para erro

        @ Atribui os ponteiros às regiões de memória
        LDR     r1, =DATA_A              @ Endereço de DATA_A
        STR     r0, [r1]                 @ Armazena LW_virtual + DATA_A
        LDR     r1, =DATA_B              @ Endereço de DATA_B
        STR     r0, [r1]                 @ Armazena LW_virtual + DATA_B
        LDR     r1, =START               @ Endereço de START
        STR     r0, [r1]                 @ Armazena LW_virtual + START
        LDR     r1, =WRFULL              @ Endereço de WRFULL
        STR     r0, [r1]                 @ Armazena LW_virtual + WRFULL

        MOV     r0, #0                   @ Retorna 0 em caso de sucesso
        BX      lr

.error_open:
        @ Lidar com erro ao abrir /dev/mem
        MOV     r0, #-1                  @ Retorna -1
        BX      lr

.error_mmap:
        @ Lidar com erro ao fazer mmap
        MOV     r0, #-1                  @ Retorna -1
        BX      lr

gpu_exit:
        LDR     r0, =LW_virtual          @ Carrega LW_virtual
        LDR     r1, =LW_BRIDGE_SPAN      @ Carrega o tamanho do mapeamento
        BL      munmap                   @ Desfaz o mapeamento
        BX      lr

send_instruction:
        MOV     r1, #0                   @ Desabilita o sinal de start
        STR     r1, [START_PTR]          @ Escreve em START_PTR
        LDR     r1, [r0]                 @ Carrega opcode_enderecamentos
        STR     r1, [DATA_A_PTR]         @ Escreve opcode em DATA_A_PTR
        LDR     r1, [r0, #4]             @ Carrega dados
        STR     r1, [DATA_B_PTR]         @ Escreve dados em DATA_B_PTR
        MOV     r1, #1                   @ Habilita o sinal de start
        STR     r1, [START_PTR]          @ Escreve em START_PTR
        MOV     r1, #0                   @ Desabilita o sinal de start
        STR     r1, [START_PTR]          @ Escreve em START_PTR
        BX      lr

instrucao_wbr:
        LDR     r1, =WBR                  @ Carrega o opcode WBR
        LDR     r2, [r0]                  @ Carrega r, g, b de r0
        LSR     r3, r2, #3                 @ g
        LSL     r3, r3, #3                 @ g << 3
        LSL     r2, r2, #6                 @ b << 6
        ORR     r2, r2, r3                 @ (b << 6) | (g << 3)
        ORR     r0, r2, r1                 @ dados = (b << 6) | (g << 3) | r

        BL      send_instruction            @ Chama send_instruction
        BX      lr

instrucao_wbr_sprite:
        LDR     r1, =WBR                  @ Carrega o opcode WBR
        LDR     r2, =0                     @ Inicializa dados
        LSL     r3, r0, #4                 @ reg << 4
        ORR     r2, r2, r3                 @ opcode_reg = (reg << 4) | WBR
        LDR     r3, =offset                @ offset
        LSL     r4, r1, #9                  @ y << 9
        LSL     r5, r0, #19                 @ x << 19
        ORR     r2, r2, r3                 @ dados = offset
        ORR     r2, r2, r4                 @ | (y << 9)
        ORR     r2, r2, r5                 @ | (x << 19)

        @ Se sprite for verdadeiro, define o bit 29
        CMP     r6, #0
        BEQ     .skip_sprite
        ORR     r2, r2, #0x20000000        @ Set bit 29
.skip_sprite:
        BL      send_instruction            @ Chama send_instruction
        BX      lr

instrucao_wbm:
        LDR     r1, =WBM                   @ Carrega o opcode WBM
        LDR     r2, [r0]                   @ Carrega address de r0
        LDR     r3, [r0, #4]               @ Carrega r
        LDR     r4, [r0, #8]               @ Carrega g
        LDR     r5, [r0, #12]              @ Carrega b

        LSL     r3, r3, #3                  @ g << 3
        LSL     r4, r4, #6                  @ b << 6
        ORR     r0, r3, r4                  @ dados = (g << 3) | (b << 6)
        LSL     r2, r2, #4                  @ address << 4
        ORR     r0, r0, r1                  @ opcode_reg = (address << 4) | opcode
        BL      send_instruction            @ Chama send_instruction
        BX      lr

instrucao_wsm:
        LDR     r1, =WSM                   @ Carrega o opcode WSM
        LDR     r2, [r0]                   @ Carrega address de r0
        LDR     r3, [r0, #4]               @ Carrega r
        LDR     r4, [r0, #8]               @ Carrega g
        LDR     r5, [r0, #12]              @ Carrega b

        LSL     r3, r3, #3                  @ g << 3
        LSL     r4, r4, #6                  @ b << 6
        ORR     r0, r3, r4                  @ dados = (g << 3) | (b << 6)
        LSL     r2, r2, #4                  @ address << 4
        ORR     r0, r0, r1                  @ opcode_reg = (address << 4) | opcode
        BL      send_instruction            @ Chama send_instruction
        BX      lr

instrucao_dp:
        LDR     r1, =DP                    @ Carrega o opcode DP
        LDR     r2, [r0]                   @ Carrega address de r0
        LDR     r3, [r0, #4]               @ Carrega ref_x
        LDR     r4, [r0, #8]               @ Carrega ref_y
        LDR     r5, [r0, #12]              @ Carrega size
        LDR     r6, [r0, #16]              @ Carrega r
        LDR     r7, [r0, #20]              @ Carrega g
        LDR     r8, [r0, #24]              @ Carrega b
        LDR     r9, [r0, #28]              @ Carrega shape

        LSL     r6, r6, #6                  @ b << 6
        LSL     r7, r7, #3                  @ g << 3
        ORR     r2, r6, r7                  @ rgb = (b << 6) | (g << 3) | r
        LSL     r2, r2, #22                 @ rgb << 22
        LSL     r5, r5, #18                 @ size << 18
        LSL     r4, r4, #9                  @ ref_y << 9
        ORR     r3, r4, r3                  @ dados = (rgb << 22) | (size << 18) | (ref_y << 9) | ref_x
        CMP     r9, #0                      @ Se shape
        BEQ     .send_instruction_dp
        ORR     r3, r3, #0x80000000         @ Set bit 31
.send_instruction_dp:
        LSL     r2, r2, #4                  @ address << 4
        ORR     r3, r3, r1                  @ opcode_reg = (address << 4) | opcode
        BL      send_instruction            @ Chama send_instruction
        BX      lr
