.global gpuMapping
.global closeGpuMapping
.global sendInstruction
.global setPolygon
.global setSprite
.global setBackgroundColor
.global setBackgroundBlock
.global isFull

.equ DATA_A_BASE, 0x80                @ Barramento â€œAâ€ de dados do buffer de instruÃ§Ã£o.
.equ DATA_B_BASE, 0x70                @ Barramento â€œBâ€ de dados do buffer de instruÃ§Ã£o.
.equ WRFULL_BASE, 0xb0                @ Sinal que informa se o buffer de instruÃ§Ã£o estÃ¡ cheio ou nÃ£o.
.equ WRREG_BASE,  0xc0                @ Sinal de escrita do buffer de instruÃ§Ã£o.
            

.type gpuMapping, %function
gpuMapping:

    PUSH {LR}
    @ Open "/dev/mem"
    LDR R0, =DEV_MEM_PATH         @ Carrega a string "/dev/mem"
    MOV R1, #2                    @ O_RDWR
    MOV R2, #0
    MOV R7, #5                    @ syscall number for open (Linux ARM)
    SVC 0                        @ Faz a chamada de sistema (open)
    LDR R1, =fd
    STR R0, [R1]                  @ Salva o resultado da chamada em fd

    MOV R4, R0

    @ Mmap LW
    MOV R0, #0                    @ addr: NULL
    MOV R1, #4096                 @ length         
    MOV R2, #3                    @ prot: PROT_READ | PROT_WRITE
    MOV R3, #1                    @ flags: MAP_SHARED
                                  @ Carregar fd
    LDR R5, =ALT_LWFPGASLVS_OFST  @ offset: ALT_LWFPGASLVS_OFST
    LDR R5, [R5]
    MOV R7, #192                  @ syscall number for mmap2 (Linux ARM)
    SVC 0                         @ Faz a chamada de sistema (mmap)
    LDR R1, =virtual_base
    STR R0, [R1]

    MOV R0, #1                    
    POP {LR}
    BX LR

.type closeGpuMapping, %function
closeGpuMapping:

    PUSH {LR}

    LDR R0, =virtual_base
    LDR R0, [R0]
    MOV R1, #4096
    MOV R7, #91               @ syscall number for munmap (Linux ARM)
    SVC 0                     @ Faz a chamada de sistema (munmap)

    LDR R0, =fd
    LDR R0, [R0]
    MOV R7, #6                @ syscall number for close (Linux ARM)
    SVC 0

    MOV R0, #1 
    POP {LR}
    BX LR

.type isFull, %function
isFull:

    LDR R1, =virtual_base
    LDR R1, [R1]
    LDR R0, [R1,#WRFULL_BASE]              @ Carrega o endereÃ§o de lw_ptr_wrFull_addr
    BX LR

.type sendInstruction, %function
sendInstruction:

    PUSH {R0, R1, LR}
    BL isFull
    MOV R5, R0
    POP {R0, R1}
    CMP R5, #0
    BNE end_sendInstruction   @ Se a FIFO estiver cheia, sai da funcao
    LDR R3, =virtual_base
    LDR R3, [R3]
    MOV R2, #0
    STR R2, [R3,#WRREG_BASE]
    STR R0, [R3,#DATA_A_BASE]
    STR R1, [R3,#DATA_B_BASE]
    MOV R2, #1
    STR R2, [R3,#WRREG_BASE]
    MOV R2, #0
    STR R2, [R3,#WRREG_BASE]

end_sendInstruction:

    POP {LR}
    BX LR

.type dataA, %function
dataA:

    PUSH {LR}
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
    POP {LR}
    BX LR

.type setBackgroundBlock, %function
setBackgroundBlock:

    POP {R4}
    PUSH {R0, R1, R2, R3, R4, LR}

    @ Calcular address = (line * 80) + column
    MOV R6, R2              @ R4 = line
    MOV R5, #80             @ Multiplicador 80
    MUL R4, R6, R5          @ R4 = line * 80
    ADD R4, R4, R1          @ R4 = (line * 80) + column

    @ Chama dataA(2, 0, address)
    MOV R0, #2              @ opcode = 2
    MOV R1, #0              @ reg = 0
    MOV R2, R4              @ memory_address = address
    BL dataA                @ Chama dataA
    MOV R5, R0              @ Armazena o resultado de dataA (R5)
    POP {R0, R1, R2, R3, R4}

    @ Construir color
    MOV R6, R4              @ color = B
    LSL R6, R6, #3          @ color = color << 3
    ORR R6, R6, R3          @ color = color | G
    LSL R6, R6, #3          @ color = color << 3
    ORR R6, R6, R2          @ color = color | R

    @ Chama sendInstruction(dataA, color)
    MOV R0, R5              @ dataA -> R0
    MOV R1, R6              @ color -> R1
    BL sendInstruction

    POP {LR}
    BX LR

.data
    fd:                     .word 0                   @ Ponteiro para o descritor de arquivo
    virtual_base:           .word 0                   @ Ponteiro para o endereÃ§o mapeado na memÃ³ria
    DEV_MEM_PATH:           .asciz "/dev/mem"         @ Caminho para o dispositivo de memÃ³ria
    ALT_LWFPGASLVS_OFST:    .word 0xff200             @ Offset do barramento de FPGA    
    