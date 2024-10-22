.section .data
fd:                     .word 0                   @ Ponteiro para o descritor de arquivo
virtual_base:           .word 0                   @ Ponteiro para o endereço mapeado na memória
h2p_lw_dataA_addr:      .word 0                   @ Ponteiro para o registrador de dados A
h2p_lw_dataB_addr:      .word 0                   @ Ponteiro para o registrador de dados B
h2p_lw_wrReg_addr:      .word 0                   @ Ponteiro para o registrador de escrita
h2p_lw_wrFull_addr:     .word 0                   @ Ponteiro para o registrador de status de FIFO cheia
DEV_MEM_PATH:           .asciz "/dev/mem"         @ Caminho para o dispositivo de memória
HW_REGS_SPAN:           .word 0x40000             @ Tamanho do espaço de registradores
HW_REGS_BASE:           .word 0xff200000          @ Base dos registradores de hardware
ALT_LWFPGASLVS_OFST:    .word 0xC0000000          @ Offset do barramento de FPGA
DATA_A_BASE:            .word 0x00000000          @ Endereço base de dados A
HW_REGS_MASK:           .word 0xFFFFF000          @ Máscara dos registradores
error_msg_open:         .asciz "[ERROR]: Você não pode abrir: \"/dev/mem\"...\n"
error_msg_mmap:         .asciz "[ERROR]: Falhou o mmap...\n"
error_msg_munmap:       .asciz "[ERROR]: Falhou o desmapeamento...\n"

.section .text
.global gpuMapping
.global closeGpuMapping
.global sendInstruction
.global dataA
.global setPolygon
.global setSprite
.global setBackgroundColor
.global setBackgroundBlock
.global isFull

.type gpuMapping, %function
gpuMapping:

    PUSH {R4, LR}

    @ Open "/dev/mem"
    LDR R0, =DEV_MEM_PATH         @ Carrega a string "/dev/mem"
    MOV R1, #2                    @ O_RDWR
    ORR R1, R1, #040000           @ O_SYNC
    MOV R7, #5                    @ syscall number for open (Linux ARM)
    SVC #0                        @ Faz a chamada de sistema (open)
    CMP R0, #0
    BLT error_open_mem
    LDR R1, =fd
    STR R0, [R1]                  @ Salva o resultado da chamada em fd

    @ Mmap HW_REGS_BASE
    MOV R0, #0                    @ addr: NULL
    LDR R1, =HW_REGS_SPAN        @ length
    MOV R2, #3                    @ prot: PROT_READ | PROT_WRITE
    MOV R3, #1                    @ flags: MAP_SHARED
    LDR R4, =fd                   @ Carregar fd
    LDR R4, [R4]                  @ Carregar o valor de fd
    LDR R5, =HW_REGS_BASE         @ offset: HW_REGS_BASE
    MOV R7, #192                  @ syscall number for mmap2 (Linux ARM)
    SVC #0                        @ Faz a chamada de sistema (mmap)
    CMP R0, #0                    @ Verifica se o retorno é MAP_FAILED
    BEQ error_mmap                @ Se for MAP_FAILED, vai para erro

    LDR R1, =virtual_base
    STR R0, [R1]                  @ Salva o ponteiro virtual_base

    MOV R0, #1                    @ Retorno de sucesso
    POP {R4, LR}
    BX LR

error_open_mem:
    LDR R0, =error_msg_open
    MOV R7, #4                    @ syscall number for write (Linux ARM)
    SVC #0                        @ printf("[ERROR]: could not open \"/dev/mem\"...\n")
    MOV R0, #-1
    POP {R4, LR}
    BX LR

error_mmap:
    LDR R0, =error_msg_mmap
    MOV R7, #4                    @ syscall number for write (Linux ARM)
    SVC #0                        @ printf("[ERROR]: mmap() failed...\n")
    LDR R1, =fd
    LDR R0, [R1]
    MOV R7, #6                    @ syscall number for close (Linux ARM)
    SVC #0
    MOV R0, #-1
    POP {R4, LR}
    BX LR

.type closeGpuMapping, %function
closeGpuMapping:

    PUSH {LR}
    LDR R1, =virtual_base
    LDR R0, [R1]
    LDR R1, =HW_REGS_SPAN
    MOV R7, #91               @ syscall number for munmap (Linux ARM)
    SVC #0                    @ Faz a chamada de sistema (munmap)
    CMP R0, #0
    BNE error_munmap
    LDR R1, =fd
    LDR R0, [R1]
    MOV R7, #6                @ syscall number for close (Linux ARM)
    SVC #0
    POP {LR}
    BX LR

error_munmap:

    LDR R0, =error_msg_munmap
    MOV R7, #4                @ syscall number for write (Linux ARM)
    SVC #0                    @ printf("[ERROR]: munmap() failed...\n")
    LDR R1, =fd
    LDR R0, [R1]
    MOV R7, #6                @ syscall number for close (Linux ARM)
    SVC #0
    POP {LR}
    BX LR

.type isFull, %function
isFull:

    LDR R1, =h2p_lw_wrFull_addr
    LDR R0, [R1]              @ Carrega o endereço de h2p_lw_wrFull_addr
    LDR R0, [R0]              @ *(uint32_t *) h2p_lw_wrFull_addr
    BX LR

.type sendInstruction, %function
sendInstruction:

    PUSH {R4, LR}
    BL isFull
    CMP R0, #0
    BNE end_sendInstruction   @ Se a FIFO estiver cheia, sai da função
    LDR R1, =h2p_lw_wrReg_addr
    LDR R1, [R1]
    MOV R2, #0
    STR R2, [R1]              @ *(uint32_t *) h2p_lw_wrReg_addr = 0
    LDR R3, =h2p_lw_dataA_addr
    LDR R3, [R3]
    STR R0, [R3]              @ *(uint32_t *) h2p_lw_dataA_addr = dataA
    LDR R4, =h2p_lw_dataB_addr
    LDR R4, [R4]
    STR R1, [R4]              @ *(uint32_t *) h2p_lw_dataB_addr = dataB
    MOV R2, #1
    STR R2, [R1]              @ *(uint32_t *) h2p_lw_wrReg_addr = 1
    MOV R2, #0
    STR R2, [R1]              @ *(uint32_t *) h2p_lw_wrReg_addr = 0
	
end_sendInstruction:

    POP {R4, LR}
    BX LR

.type dataA, %function
dataA:
    PUSH {R4, R5, LR}
    MOV R4, #0              @ Inicializa o valor de data = 0
    CMP R0, #0              @ Verifica se opcode == 0
    BEQ opcode_0            @ Se for igual, vai para opcode_0
    CMP R0, #1
    BEQ opcode_mem          @ Se for 1, 2 ou 3, trata como memory_address
    CMP R0, #2
    BEQ opcode_mem
    CMP R0, #3
    BEQ opcode_mem

opcode_0:
    ORR R4, R4, R1          @ data = data | reg
    LSL R4, R4, #4          @ data = data << 4
    ORR R4, R4, R0          @ data = data | opcode
    B end_dataA

opcode_mem:
    ORR R4, R4, R2          @ data = data | memory_address
    LSL R4, R4, #4          @ data = data << 4
    ORR R4, R4, R0          @ data = data | opcode

end_dataA:
    MOV R0, R4              @ Retorna data
    POP {R4, R5, LR}
    BX LR

.type setPolygon, %function
setPolygon:
    PUSH {R4, R5, R6, R7, LR}
    
    @ Chama dataA(opcode, 0, address)
    MOV R1, #0              @ reg = 0
    BL dataA         @ Chama dataA
    MOV R4, R0              @ Armazena o resultado em dataA (R4)
    
    @ Construir dataB
    MOV R5, #0              @ Inicializa dataB = 0
    ORR R5, R5, R3          @ dataB = dataB | form
    LSL R5, R5, #9          @ dataB = dataB << 9
    ORR R5, R5, R2          @ dataB = dataB | color
    LSL R5, R5, #4          @ dataB = dataB << 4
    ORR R5, R5, R4          @ dataB = dataB | mult
    LSL R5, R5, #9          @ dataB = dataB << 9
    ORR R5, R5, R6          @ dataB = dataB | ref_point_y
    LSL R5, R5, #9          @ dataB = dataB << 9
    ORR R5, R5, R7          @ dataB = dataB | ref_point_x
    
    @ Chama sendInstruction(dataA, dataB)
    MOV R0, R4              @ dataA -> R0
    MOV R1, R5              @ dataB -> R1
    BL sendInstruction

    POP {R4, R5, R6, R7, LR}
    BX LR

.type setSprite, %function
setSprite:
    PUSH {R4, R5, LR}
    
    @ Chama dataA(0, registrador, 0)
    MOV R0, #0              @ opcode = 0
    MOV R2, #0              @ memory_address = 0
    BL dataA         @ Chama dataA
    MOV R4, R0              @ Armazena o resultado em dataA (R4)
    
    @ Construir dataB
    MOV R5, #0              @ Inicializa dataB = 0
    ORR R5, R5, R4          @ dataB = dataB | activation_bit
    LSL R5, R5, #10         @ dataB = dataB << 10
    ORR R5, R5, R1          @ dataB = dataB | x
    LSL R5, R5, #10         @ dataB = dataB << 10
    ORR R5, R5, R2          @ dataB = dataB | y
    LSL R5, R5, #9          @ dataB = dataB << 9
    ORR R5, R5, R3          @ dataB = dataB | offset
    
    @ Chama sendInstruction(dataA, dataB)
    MOV R0, R4              @ dataA -> R0
    MOV R1, R5              @ dataB -> R1
    BL sendInstruction

    POP {R4, R5, LR}
    BX LR

.type setBackgroundColor, %function
setBackgroundColor:
    PUSH {R4, LR}

    @ Chama dataA(0, 0, 0)
    MOV R0, #0              @ opcode = 0
    MOV R1, #0              @ reg = 0
    MOV R2, #0              @ memory_address = 0
    BL dataA         @ Chama dataA
    MOV R4, R0              @ Armazena o resultado de dataA (R4)

    @ Construir color
    MOV R5, R3              @ color = B
    LSL R5, R5, #3          @ color = color << 3
    ORR R5, R5, R2          @ color = color | G
    LSL R5, R5, #3          @ color = color << 3
    ORR R5, R5, R1          @ color = color | R

    @ Chama sendInstruction(dataA, color)
    MOV R0, R4              @ dataA -> R0
    MOV R1, R5              @ color -> R1
    BL sendInstruction

    POP {R4, LR}
    BX LR

.type setBackgroundBlock, %function
setBackgroundBlock:
    PUSH {R4, R5, LR}

    @ Calcular address = (line * 80) + column
    MOV R4, R2              @ R4 = line
    MOV R5, #80             @ Multiplicador 80
    MUL R4, R4, R5          @ R4 = line * 80
    ADD R4, R4, R1          @ R4 = (line * 80) + column

    @ Chama dataA(2, 0, address)
    MOV R0, #2              @ opcode = 2
    MOV R1, #0              @ reg = 0
    MOV R2, R4              @ memory_address = address
    BL dataA         @ Chama dataA
    MOV R4, R0              @ Armazena o resultado de dataA (R4)

    @ Construir color
    MOV R5, R3              @ color = B
    LSL R5, R5, #3          @ color = color << 3
    ORR R5, R5, R2          @ color = color | G
    LSL R5, R5, #3          @ color = color << 3
    ORR R5, R5, R1          @ color = color | R

    @ Chama sendInstruction(dataA, color)
    MOV R0, R4              @ dataA -> R0
    MOV R1, R5              @ color -> R1
    BL sendInstruction

    POP {R4, R5, LR}
    BX LR




