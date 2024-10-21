.section .data
LW_BRIDGE_BASE: .word 0xFF200000        @ Defina o endereço base da ponte
LW_BRIDGE_SPAN: .word 0x00005000        @ Defina o tamanho da memória da ponte
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

DATA_A_PTR:    .word 0                  @ Ponteiro para DATA_A
DATA_B_PTR:    .word 0                  @ Ponteiro para DATA_B
START_PTR:     .word 0                  @ Ponteiro para START
WRFULL_PTR:    .word 0                  @ Ponteiro para WRFULL

.section .text
.global gpu_init
.global gpu_exit
.global send_instruction
.global instruction_wbr
.global instruction_wbm
.global instruction_wsm
.global instruction_dp

.type gpu_init, %function
gpu_init:

    LDR     R0, =DEV_MEM_PATH            @ Carrega o caminho do arquivo
    MOV     R7, #5                       @ syscall: open
    MOV     R1, #2                       @ O_RDWR
    SVC     0                            @ Chama a syscall
    MOV     R4, R0                       @ fd é retornado em R0
    CMP     R0, #-1                      @ Verifica se fd é -1
    BLT     .error_open                  @ Se sim, vai para erro

    LDR     R0, =LW_BRIDGE_BASE          @ Endereço base da memória
    LDR     R1, =LW_BRIDGE_SPAN          @ Tamanho da memória
    MOV     R2, #3                       @ PROT_READ | PROT_WRITE
    MOV     R3, #1                       @ MAP_SHARED
    MOV     R7, #192                     @ syscall: mmap (Falta confirmar 192)
    SVC     0                            @ Chama a syscall
    LDR     R1, =LW_VIRTUAL              @ Carrega o endereço de LW_virtual
    STR     R0, [R1]                     @ Armazena o ponteiro de memória virtual retornado por mmap
    LDR     R5, [R1]                     @ Carrega LW_virtual
    CMP     R5, #0                       @ Verifica se LW_virtual é MAP_FAILED
    BEQ     .error_mmap                  @ Se sim, vai para erro

    @ Atribui os ponteiros às regiões de memória
    LDR     R6, =DATA_A                  @ Offset de DATA_A
    ADD     R6, R5, R6                   @ DATA_A_PTR = LW_virtual + DATA_A
    LDR     R7, =DATA_A_PTR              @ Carrega o endereço de DATA_A_PTR
    STR     R6, [R7]                     @ Armazena o ponteiro em DATA_A_PTR

    LDR     R6, =DATA_B                  @ Offset de DATA_B
    ADD     R6, R5, R6                   @ DATA_B_PTR = LW_virtual + DATA_B
    LDR     R7, =DATA_B_PTR              @ Carrega o endereço de DATA_B_PTR
    STR     R6, [R7]                     @ Armazena o ponteiro em DATA_B_PTR

    LDR     R6, =START                   @ Offset de START
    ADD     R6, R5, R6                   @ START_PTR = LW_virtual + START
    LDR     R7, =START_PTR               @ Carrega o endereço de START_PTR
    STR     R6, [R7]                     @ Armazena o ponteiro em START_PTR

    LDR     R6, =WRFULL                  @ Offset de WRFULL
    ADD     R6, R5, R6                   @ WRFULL_PTR = LW_virtual + WRFULL
    LDR     R7, =WRFULL_PTR              @ Carrega o endereço de WRFULL_PTR
    STR     R6, [R7]                     @ Armazena o ponteiro em WRFULL_PTR

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
    SVC     0                            @ Chama a syscall
    BX      LR

.type send_instruction, %function
send_instruction:

    PUSH    {LR}                          @ Salva o registrador de link

    MOV     R4, #0                        @ Desabilita o sinal de start
    LDR     R3, =START_PTR                @ Carrega START_PTR
    STR     R4, [R3]                      @ Desabilita o sinal de start

    LDR     R3, =DATA_A_PTR               @ Carrega DATA_A_PTR
    LDR     R3, [R3]                      @ Carrega o endereço armazenado em DATA_A_PTR
    STR     R0, [R3]                      @ Escreve o opcode (R0) em DATA_A_PTR

    LDR     R3, =DATA_B_PTR               @ Carrega DATA_B_PTR
    LDR     R3, [R3]                      @ Carrega o endereço armazenado em DATA_B_PTR
    STR     R1, [R3]                      @ Escreve os dados (R1) em DATA_B_PTR

    MOV     R4, #1                        @ Habilita o sinal de start
    STR     R4, [R3]                      @ Escreve em START_PTR
    MOV     R4, #0                        @ Desabilita o sinal de start
    STR     R4, [R3]                      @ Escreve em START_PTR

    POP     {LR}                          @ Restaura o registrador de link
    BX      LR                            @ Retorna


.type instruction_wbr, %function
instruction_wbr:

    PUSH    {LR}                          @ Salva o registrador de link
    SUB     SP, SP, #12                   @ Aloca espaço na pilha para 3 parâmetros (r, g, b)

    STR     R0, [SP, #0]                  @ Armazena r na pilha
    STR     R1, [SP, #4]                  @ Armazena g na pilha
    STR     R2, [SP, #8]                  @ Armazena b na pilha

    LDR     R0, [SP, #0]                  @ Carrega r
    LDR     R1, [SP, #4]                  @ Carrega g
    LDR     R2, [SP, #8]                  @ Carrega b

    LSL     R1, R1, #3                    @ g << 3 (desloca g para a esquerda 3 bits)
    LSL     R2, R2, #6                    @ b << 6 (desloca b para a esquerda 6 bits)

    ORR     R1, R2, R1                    @ dados = (b << 6) | (g << 3)
    ORR     R1, R1, R0                    @ dados |= r

    LDR     R0, =WBR                      @ Carrega o opcode WBR
    BL      send_instruction              @ Chama send_instruction

    ADD     SP, SP, #12                   @ Libera o espaço alocado na pilha
    POP     {LR}                          @ Restaura o registrador de link
    BX      LR                            @ Retorna


.type instruction_wbr_sprite, %function
instruction_wbr_sprite:

    PUSH    {LR}                          @ Salva o registrador de link
    SUB     SP, SP, #20                   @ Aloca espaço na pilha para 5 parâmetros (reg, offset, x, y, sp)

    STR     R0, [SP, #0]                  @ Armazena reg (R0) na pilha
    STR     R1, [SP, #4]                  @ Armazena offset na pilha
    STR     R2, [SP, #8]                  @ Armazena x na pilha
    STR     R3, [SP, #12]                 @ Armazena y na pilha
    STR     R4, [SP, #16]                 @ Armazena sp na pilha

    LDR     R5, =WBR                      @ Carrega o opcode WBR

    LDR     R0, [SP, #0]                  @ Carrega reg de R0
    LSL     R0, R0, #4                    @ reg << 4
    ORR     R0, R0, R5                    @ opcode_reg = (reg << 4) | opcode

    LDR     R1, [SP, #4]                  @ Carrega offset de R1
    LDR     R2, [SP, #8]                  @ Carrega x de R2
    LDR     R3, [SP, #12]                 @ Carrega y de R3
    LDR     R4, [SP, #16]                 @ Carrega sp de R4

    MOV     R6, R1                        @ Inicializa dados com offset
    LSL     R3, R3, #9                    @ y << 9
    ORR     R6, R6, R3                    @ dados = offset | (y << 9)
    LSL     R2, R2, #19                   @ x << 19
    ORR     R6, R6, R2                    @ dados = dados | (x << 19)

    CMP     R4, #0                        @ Verifica se sp é 0
    BNE     send_instruction_wbr_sprite   @ Se sp != 0, vai para habilitar sprite

    ORR     R6, R6, #0x20000000           @ Habilita sprite se sp for 1    
    MOV     R1, R6                        @ Armazena os dados finais em R1

send_instruction_wbr_sprite:

    BL      send_instruction              @ Chama send_instruction

    ADD     SP, SP, #20                   @ Libera espaço na pilha
    POP     {LR}                          @ Restaura o registrador de link
    BX      LR                            @ Retorna


.type instruction_wbm, %function
instruction_wbm:

    PUSH    {LR}                          @ Salva o registrador de link
    SUB     SP, SP, #20                   @ Aloca espaço na pilha para 5 parâmetros (address, R, G, B)

    STR     R0, [SP, #0]                  @ Armazena address (R0) na pilha
    STR     R1, [SP, #4]                  @ Armazena R na pilha
    STR     R2, [SP, #8]                  @ Armazena G na pilha
    STR     R3, [SP, #12]                 @ Armazena B na pilha

    LDR     R1, =WBM                      @ Carrega o opcode WBM

    LDR     R2, [SP, #0]                  @ Carrega address de R0
    LDR     R3, [SP, #4]                  @ Carrega R
    LDR     R4, [SP, #8]                  @ Carrega G
    LDR     R5, [SP, #12]                 @ Carrega B

    LSL     R4, R4, #3                    @ G << 3
    LSL     R5, R5, #6                    @ B << 6

    ORR     R1, R3, R4                    @ dados = (R) | (G << 3)
    ORR     R1, R1, R5                    @ dados = dados | (B << 6)

    LSL     R2, R2, #4                    @ address << 4
    ORR     R0, R2, R1                    @ opcode_reg = (address << 4) | opcode

    BL      send_instruction              @ Chama send_instruction

    ADD     SP, SP, #20                   @ Libera o espaço alocado na pilha
    POP     {LR}                          @ Restaura o registrador de link
    BX      LR                            @ Retorna



.type instruction_wsm, %function
instruction_wsm:

    PUSH    {LR}                          @ Salva o registrador de link
    SUB     SP, SP, #20                   @ Aloca espaço na pilha para 5 parâmetros (address, R, G, B)

    STR     R0, [SP, #0]                  @ Armazena address (R0) na pilha
    STR     R1, [SP, #4]                  @ Armazena R na pilha
    STR     R2, [SP, #8]                  @ Armazena G na pilha
    STR     R3, [SP, #12]                 @ Armazena B na pilha

    LDR     R1, =WSM                      @ Carrega o opcode WSM

    LDR     R2, [SP, #0]                  @ Carrega address de R0
    LDR     R3, [SP, #4]                  @ Carrega R
    LDR     R4, [SP, #8]                  @ Carrega G
    LDR     R5, [SP, #12]                 @ Carrega B

    LSL     R4, R4, #3                    @ G << 3
    LSL     R5, R5, #6                    @ B << 6

    ORR     R1, R3, R4                    @ dados = (R) | (G << 3)
    ORR     R1, R1, R5                    @ dados = dados | (B << 6)

    LSL     R2, R2, #4                    @ address << 4
    ORR     R0, R2, R1                    @ opcode_reg = (address << 4) | opcode

    BL      send_instruction              @ Chama send_instruction

    ADD     SP, SP, #20                   @ Libera o espaço alocado na pilha
    POP     {LR}                          @ Restaura o registrador de link
    BX      LR                            @ Retorna

.type instruction_dp, %function
instruction_dp:

    PUSH    {LR}                          @ Salva o registrador de link
    SUB     SP, SP, #32                   @ Aloca espaço na pilha para 8 parâmetros (address, ref_x, ref_y, size, R, G, B, shape)

    STR     R0, [SP, #0]                  @ Armazena address (R0) na pilha
    STR     R1, [SP, #4]                  @ Armazena ref_x na pilha
    STR     R2, [SP, #8]                  @ Armazena ref_y na pilha
    STR     R3, [SP, #12]                 @ Armazena size na pilha
    STR     R4, [SP, #16]                 @ Armazena R na pilha
    STR     R5, [SP, #20]                 @ Armazena G na pilha
    STR     R6, [SP, #24]                 @ Armazena B na pilha
    STR     R7, [SP, #28]                 @ Armazena shape na pilha

    LDR     R2, [SP, #0]                  @ Carrega address de R0
    LDR     R3, [SP, #4]                  @ Carrega ref_x
    LDR     R4, [SP, #8]                  @ Carrega ref_y
    LDR     R5, [SP, #12]                 @ Carrega size
    LDR     R6, [SP, #16]                 @ Carrega R
    LDR     R7, [SP, #20]                 @ Carrega G
    LDR     R8, [SP, #24]                 @ Carrega B
    LDR     R9, [SP, #28]                 @ Carrega shape

    LSL     R7, R7, #3                    @ G << 3
    LSL     R8, R8, #6                    @ B << 6

    ORR     R1, R6, R7                    @ rgb = (R) | (G << 3)
    ORR     R1, R1, R8                    @ rgb = (rgb) | (B << 6)

    LSL     R1, R1, #22                   @ dados = (rgb << 22)
    LSL     R5, R5, #18                   @ size << 18
    ORR     R1, R1, R5                    @ dados |= (size << 18)

    LSL     R4, R4, #9                    @ ref_y << 9
    ORR     R1, R1, R4                    @ dados |= (ref_y << 9)

    ORR     R1, R1, R3                    @ dados |= ref_x

    LSL     R2, R2, #4                    @ address << 4
    LDR     R0, =DP                       @ Carrega o opcode DP
    ORR     R0, R2, R0                    @ opcode_reg = (address << 4) | opcode

    CMP     R9, #0                        @ Verifica se shape é 0
    BNE     send_instruction_dp           @ Se shape != 0, pula para enviar a instrução

    ORR     R1, R1, #0x80000000           @ Se shape == 0, habilita o bit 31

send_instruction_dp:

    BL      send_instruction              @ Chama send_instruction

    ADD     SP, SP, #32                   @ Libera espaço na pilha
    POP     {LR}                          @ Restaura o registrador de link
    BX      LR                            @ Retorna









