.section .data
LW_BRIDGE_BASE: .word 0x00000000        @ Defina o endereço base da ponte
LW_BRIDGE_SPAN: .word 0x00000010        @ Defina o tamanho da memória da ponte
DATA_A:         .word 0x80              @ Offset para DATA_A
DATA_B:         .word 0x70              @ Offset para DATA_B
START:          .word 0xc0              @ Offset para START
WRFULL:         .word 0xb0              @ Offset para WRFULL
WBR:            .word 0b00              @ Código de operação WBR
WBM:            .word 0b10              @ Código de operação WBM
WSM:            .word 0b01              @ Código de operação WSM
DP:             .word 0b11              @ Código de operação DP
LW_VIRTUAL:     .word 0                 @ Variável para LW_virtual
DEV_MEM_PATH:   .asciz "/dev/mem"       @ Caminho para /dev/mem

.section .text
.global gpu_init
.global gpu_exit
.global send_instruction
.global instrucao_wbr
.global instrucao_wbm
.global instrucao_wsm
.global instrucao_dp

.type gpu_init, %function
gpu_init:
    LDR     R0, =DEV_MEM_PATH            @ Carrega o caminho do arquivo
    MOV     R7, #5                       @ syscall: open
    MOV     R1, #2                       @ O_RDWR
    SWI     0                            @ Chama a syscall
    MOV     R4, R0                       @ fd é retornado em R0
    CMP     R0, #-1                      @ Verifica se fd é -1 (corrigido)
    BLT     .error_open                  @ Se sim, vai para erro

    LDR     R0, =LW_BRIDGE_BASE          @ Endereço base da memória
    LDR     R1, =LW_BRIDGE_SPAN          @ Tamanho da memória
    MOV     R2, #3                       @ PROT_READ | PROT_WRITE
    MOV     R3, #1                       @ MAP_SHARED
    MOV     R7, #192                     @ syscall: mmap (Falta confirmar 192)
    SWI     0                            @ Chama a syscall
    LDR     R1, =LW_VIRTUAL              @ Carrega o endereço de LW_virtual
    STR     R0, [R1]                     @ Armazena o ponteiro de memória virtual retornado por mmap
    LDR     R5, [R1]                     @ Carrega LW_virtual
    CMP     R5, #0                       @ Verifica se LW_virtual é MAP_FAILED
    BEQ     .error_mmap                  @ Se sim, vai para erro

    @ Atribui os ponteiros às regiões de memória
    LDR     R6, =DATA_A                  @ Offset de DATA_A
    ADD     R6, R5, R6                   @ DATA_A_PTR = LW_virtual + DATA_A
    STR     R6, [R4, #0]                 @ Armazena o ponteiro em DATA_A_PTR

    LDR     R6, =DATA_B                  @ Offset de DATA_B
    ADD     R6, R5, R6                   @ DATA_B_PTR = LW_virtual + DATA_B
    STR     R6, [R4, #4]                 @ Armazena o ponteiro em DATA_B_PTR (offset de 4 bytes)

    LDR     R6, =START                   @ Offset de START
    ADD     R6, R5, R6                   @ START_PTR = LW_virtual + START
    STR     R6, [R4, #8]                 @ Armazena o ponteiro em START_PTR (offset de 8 bytes)

    LDR     R6, =WRFULL                  @ Offset de WRFULL
    ADD     R6, R5, R6                   @ WRFULL_PTR = LW_virtual + WRFULL
    STR     R6, [R4, #12]                @ Armazena o ponteiro em WRFULL_PTR (offset de 12 bytes)

    MOV     R0, #0                       @ Retorna 0 em caso de sucesso
    BX      LR

.error_open:
    @ Lidar com erro ao abrir /dev/mem
    MOV     R0, #-1                      @ Retorna -1
    BX      LR

.error_mmap:
    @ Lidar com erro ao fazer mmap
    MOV     R0, #-1                      @ Retorna -1
    BX      LR

.type gpu_exit, %function
gpu_exit:
    LDR     R0, =LW_VIRTUAL              @ Carrega LW_virtual
    LDR     R1, =LW_BRIDGE_SPAN          @ Carrega o tamanho do mapeamento
    MOV     R7, #91                      @ syscall: munmap
    SWI     0                            @ Chama a syscall
    BX      LR

.type send_instruction, %function
send_instruction:
    MOV     R1, #0                       @ Desabilita o sinal de start
    LDR     R2, =LW_VIRTUAL              @ Carrega o ponteiro de memória virtual
    LDR     R3, [R2]                     @ Carrega DATA_A_PTR
    STR     R1, [R3]                     @ Escreve em DATA_A_PTR
    LDR     R1, [R2]                     @ Carrega o opcode_enderecamentos
    STR     R1, [R3]                     @ Escreve opcode em DATA_A_PTR
    LDR     R1, [R2]                     @ Carrega dados
    STR     R1, [R3, #4]                 @ Escreve dados em DATA_B_PTR
    MOV     R1, #1                       @ Habilita o sinal de start
    STR     R1, [R3, #8]                 @ Escreve em START_PTR
    MOV     R1, #0                       @ Desabilita o sinal de start
    STR     R1, [R3, #8]                 @ Escreve em START_PTR
    BX      LR

.type instrucao_wbr, %function
instrucao_wbr:
    LDR     R1, =WBR                     @ Carrega o opcode WBR
    LDR     R2, [R0]                     @ Carrega r, g, b de R0
    LSR     R3, R2, #3                   @ g
    LSL     R3, R3, #3                   @ g << 3
    LSL     R2, R2, #6                   @ b << 6
    ORR     R2, R2, R3                   @ (b << 6) | (g << 3)
    ORR     R0, R2, R1                   @ dados = (b << 6) | (g << 3) | R

    BL      send_instruction             @ Chama send_instruction
    BX      LR

.type instrucao_wbm, %function
instrucao_wbm:
    LDR     R1, =WBM                     @ Carrega o opcode WBM
    LDR     R2, [R0]                     @ Carrega address de R0
    LDR     R3, [R0, #4]                 @ Carrega R
    LDR     R4, [R0, #8]                 @ Carrega G
    LDR     R5, [R0, #12]                @ Carrega B

    LSL     R3, R3, #3                   @ G << 3
    LSL     R4, R4, #6                   @ B << 6
    ORR     R0, R3, R4                   @ dados = (G << 3) | (B << 6)
    LSL     R2, R2, #4                   @ address << 4
    ORR     R0, R0, R1                   @ opcode_reg = (address << 4) | opcode
    BL      send_instruction             @ Chama send_instruction
    BX      LR

.type instrucao_wsm, %function
instrucao_wsm:
    LDR     R1, =WSM                     @ Carrega o opcode WSM
    LDR     R2, [R0]                     @ Carrega address de R0
    LDR     R3, [R0, #4]                 @ Carrega R
    LDR     R4, [R0, #8]                 @ Carrega G
    LDR     R5, [R0, #12]                @ Carrega B

    LSL     R3, R3, #3                   @ G << 3
    LSL     R4, R4, #6                   @ B << 6
    ORR     R0, R3, R4                   @ dados = (G << 3) | (B << 6)
    LSL     R2, R2, #4                   @ address << 4
    ORR     R0, R0, R1                   @ opcode_reg = (address << 4) | opcode
    BL      send_instruction             @ Chama send_instruction
    BX      LR

.type instrucao_dp, %function
instrucao_dp:
    LDR     R1, =DP                      @ Carrega o opcode DP
    LDR     R2, [R0]                     @ Carrega address de R0
    LDR     R3, [R0, #4]                 @ Carrega ref_x
    LDR     R4, [R0, #8]                 @ Carrega ref_y
    LDR     R5, [R0, #12]                @ Carrega size
    LDR     R6, [R0, #16]                @ Carrega R
    LDR     R7, [R0, #20]                @ Carrega G
    LDR     R8, [R0, #24]                @ Carrega B

    LSL     R6, R6, #3                   @ R << 3
    LSL     R7, R7, #6                   @ G << 6
    LSL     R8, R8, #9                   @ B << 9
    ORR     R0, R6, R7                   @ dados = (R << 3) | (G << 6)
    ORR     R0, R0, R8                   @ dados = (dados << 9) | B
    LSL     R2, R2, #4                   @ address << 4
    ORR     R0, R0, R1                   @ opcode_reg = (address << 4) | opcode
    BL      send_instruction             @ Chama send_instruction
    BX      LR
