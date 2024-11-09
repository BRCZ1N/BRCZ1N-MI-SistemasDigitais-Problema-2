.section .rodata
@PATH DO MAPEAMNENTO DE MEMORIA
DEV_MEM_PATH:
	.ascii	"/dev/mem"

@LW BASE
ALT_LWFPGASLVS_OFST:
	.word 0xFF200				

.data
@ENDEREÇO VIRTUAL GERADO PELO MAPEAMENTO DA GPU
virtual_base:			
	.zero 4						
@ARMAZENA O DESCRITOR DE ARQUIVO DO /DEV/MEM
fd:						
	.zero 4

.text
.global	gpuMapping
.type	gpuMapping, %function

.global closeGpuMapping  
.type	closeGpuMapping, %function

.global	isFull
.type	isFull, %function

.global	sendInstruction
.type	sendInstruction, %function

.global	setBackgroundColor
.type	setBackgroundColor, %function

.global	setBackgroundBlock
.type	setBackgroundBlock, %function

.global	setSprite
.type	setSprite, %function

.global	setPolygon
.type	setPolygon, %function

.global	buttonRead
.type	buttonRead, %function

@Mapeia a memória e armazena o endereço
gpuMapping:

	PUSH	{R4-R7, LR}
	LDR R0,  =DEV_MEM_PATH	@caminho do arquivo					
	MOVW R1, #2 @modo leitura e escrita
	MOVT R2, #0	@sem flags						
	MOV R7, #5	@syscall open 							
	SVC 0

	LDR R3, =fd
	STR	R0, [R3]	@Guarda o descritor de arquivos					

	MOV R4, R0								
	MOV R0, #0		@syscall do mmap2	 					
	MOV R1, #4096	 @ tamanho da página mapeada						
	MOV R2, #3		@modo leitura/escrita					
	MOV R3, #1		 @compartilha com os processos						
	LDR R5, =ALT_LWFPGASLVS_OFST							
	LDR R5, [R5]							
	MOV R7, #192	@syscall do mmap2						
	SVC 0

	LDR R1, =virtual_base
	STR R0, [R1]							

	POP {R4-R7, LR}
	BX LR

@Faz o desmapeamento da memoria e fecha o descritor de arquivo
closeGpuMapping:	

    POP {LR}

    LDR R0, =virtual_base						
    MOV R1, #4096   @ tamanho da página mapeada				
    MOV R7, #91   @ system call: munmap             				
    SVC #0                      

	CMP R0, #0								
	BEQ munmap_sucesso

	LDR R0, =fd								

    MOV R7, #6 	@ system call: close							
    SVC #0  

munmap_sucesso:

    POP {LR}
    BX LR                 

@Verifica se a FIFO ta cheia
isFull: 
   
	PUSH {LR}
	LDR R0, =virtual_base				
	LDR	R0, [R0] 
	LDR	R0, [R0, #0xb0]     @Verifica se a FIFO está full ANTES DE ENVIAR QUALQUER DADO   
	POP {LR}
    BX LR                

@Envia a instrução para a GPU
sendInstruction: 
   
	PUSH {LR}
	LDR R3, =virtual_base	@Carrega o Base			
	LDR	R3, [R3]                    

loop_sendInstruction:

	LDR	R2, [R3, #0xb0]   @Verifica se a FIFO está full ANTES DE ENVIAR QUALQUER DADO       
	CMP	R2, #0                     
	BNE loop_sendInstruction      
	
	MOV	R2, #0			   @ Sinaliza para desabilitar a instrução
	STR	R2, [R3, #0xc0]    @ Grava o sinal para desabilitar oo WRREG        

	STR	R0, [R3, #0x80]    @ Armazena o valor do registrador no dataA        

	STR	R1, [R3, #0x70]    @ Armazena o valor final RGB no dataB       

	MOV	R2, #1			   @ Sinaliza para habilitar a instrução  
	STR	R2, [R3, #0xc0]    @ Grava o sinal de habilitação no WRREG      

	MOV	R2, #0			   @ Sinaliza para desabilitar a instrução
	STR	R2, [R3, #0xc0]    @ Grava o sinal de desabilitação no WRREG         

	POP	{LR}
	BX	LR
	
@Função que seta a cor de fundo da tela 
setBackgroundColor:

    PUSH {LR}    

    LSL R2, R2, #6       @ Realiza os deslocamentos referentes a instrução   
    LSL R1, R1, #3       @ Realiza os deslocamentos referentes a instrução  

    ORR R1, R1, R2          @ Agrega os deslocamento para gerar o DATA  
    ORR R1, R1, R0          
                            
    MOV	R0, #0              

    BL sendInstruction      
    POP {LR}
	BX LR

@Função que seta uma parte do bloco de fundo da tela
setBackgroundBlock:

	PUSH {LR}				
	LSL R3, R3, #3	@ Realiza os deslocamentos referentes a instrução	
	ORR R3, R3, R2		

	LDR	R2, [SP, #4]	@ Regasta o parametro que é alocado diretamente na pilha 
	LSL R2, R2, #6		@ Realiza os deslocamentos referentes a instrução
	ORR R3, R3, R2		@ Agrega os deslocamento para gerar o DATA  

	MOV R2, #80			@Calculando o limite de endereço estabelecido pela GPU
	MUL R0, R2, R0		@Realiza o produto do endereço com a coluna 	
	ADD R0, R0, R1 		@Soma-se o valor do produto com a linha 

	LSL R0, #4			@ Realiza os deslocamentos referentes a instrução
	ADD R0, R0, #2		 @ Agrega os deslocamento para gerar o DATA

	MOV R1, R3		

	BL	sendInstruction @Salta para branch/função de envio de instrução para GPU, isto é, envia o DATA A E DATA B nos registradores R0 E R1

	POP {LR}
    BX LR

@Função para setar um sprite na tela 
setSprite:

	PUSH {LR}				

    LSL R0, R0, #4     @ Realiza os deslocamentos referentes a instrução   

    LSL R2, R2, #29    
    LSL R3, R3, #19    

    ORR R1, R1, R2      @ Agrega os deslocamento para gerar o DATA
    ORR R1, R1, R3      

    LDR	R2, [SP, #4]	@ Regasta o parametro que é alocado diretamente na pilha 
    LSL R2,R2, #9  
    ORR R1, R1, R2      
          
    BL sendInstruction     @Salta para branch/função de envio de instrução para GPU, isto é, envia o DATA A E DATA B nos registradores R0 E R1
 

    POP {LR}
    BX LR

@Função para setar um poligono na tela 
setPolygon:

	PUSH	{LR}		
   
    LSL R0, R0, #4      @ Realiza os deslocamentos referentes a instrução 
    ORR R0, R0, #3      @ Agrega os deslocamento para gerar o DATA

    LSL R1, R1, #22      @ Realiza os deslocamentos referentes a instrução
    LSL R2, R2, #31      
    LSL R3, R3, #18     
      
    ORR R1, R1, R2       @ Agrega os deslocamento para gerar o DATA
    ORR R1, R1, R3    
    
    LDR	R2, [SP,#8]      @ Regasta os parametros que são alocado diretamente na pilha 
    LDR	R3, [SP,#4]	  

    LSL R3, R3, #9      

    ORR R1, R1, R2      @ Agrega os deslocamento para gerar o DATA
    ORR R1, R1, R3      @ Agrega os deslocamento para gerar o DATA

    BL sendInstruction    @Salta para branch/função de envio de instrução para GPU, isto é, envia o DATA A E DATA B nos registradores R0 E R1
    POP {LR}
    BX LR

buttonRead:

	PUSH	{LR}		

	LDR R0, =virtual_base				
	LDR	R0, [R0] 
	LDR	R0, [R0, #0x0]    @Acessa o botão atraves do VIRTUAL BASE + O BASE DO BOTÃO
           	
    POP {LR}
    BX LR

	


