.section .rodata
DEV_MEM_PATH:
	.ascii	"/dev/mem"

ALT_LWFPGASLVS_OFST:
	.word 0xFF200				

.data
virtual_base:			
	.zero 4						

fd:						
	.zero 4

.text
.global	gpuMapping
.type	gpuMapping, %function
gpuMapping:

	PUSH	{R4-R7, LR}
	LDR R0,  =DEV_MEM_PATH						
	MOVW R1, #2
	MOVT R1, #0							
	MOV R7, #5								
	SVC #0

	LDR R3, =fd
	STR	R0, [R3]						

	MOV R4, R0								
	MOV R0, #0								
	MOV R1, #4096							
	MOV R2, #3								
	MOV R3, #1								
	LDR R5, =ALT_LWFPGASLVS_OFST							
	LDR R5, [R5]							
	MOV R7, #192							
	SVC #0

	LDR R1, =virtual_base
	STR R0, [R1]							

	POP {R4-R7, LR}
	BX LR

	.align 2
	.global closeGpuMapping  
	.type	closeGpuMapping, %function
closeGpuMapping:	

    POP {LR}

    LDR R0, =virtual_base						
    MOV R1, #4096    						
    MOV R7, #91                				
    SVC #0                      

	CMP R0, #0								
	BEQ munmap_sucesso

	LDR R0, =fd								

    MOV R7, #6 								
    SVC #0  

munmap_sucesso:

    POP {LR}
    BX LR                 

	.align 2
	.global	isFull
	.type	isFull, %function
isFull: 
   
	PUSH {LR}
	LDR R0, =virtual_base				
	LDR	R0, [R0] 
	LDR	R0, [R0, #0xb0]    
	POP {LR}
    BX LR                

	.align 2
	.global	sendInstruction
	.type	sendInstruction, %function
sendInstruction: 
   
	PUSH {LR}
	LDR R3, =virtual_base				
	LDR	R3, [R3]                    

while_sendInstruction:

	LDR	R2, [R3, #0xb0]             
	CMP	R2, #0                     
	bne	while_sendInstruction      
	
	MOV	R2, #0
	STR	R2, [R3, #0xc0]             

	STR	R0, [R3, #0x80]             

	STR	R1, [R3, #0x70]             

	MOV	R2, #1
	STR	R2, [R3, #0xc0]             

	MOV	R2, #0
	STR	R2, [R3, #0xc0]            

	POP	{LR}
	BX	LR
	
	.align 2
    .global	setBackgroundColor
    .type	setBackgroundColor, %function
setBackgroundColor:

    PUSH {LR}    

    LSL R2, R2, #6          
    LSL R1, R1, #3          

    ORR R1, R1, R2          
    ORR R1, R1, R0          
                            
    MOV	R0, #0              

    BL sendInstruction      
    POP {LR}
	BX LR

	.align 2
    .global	setBackgroundBlock
    .type	setBackgroundBlock, %function
setBackgroundBlock:

	PUSH {LR}				
	LSL R3, R3, #3		
	ORR R3, R3, R2		

	LDR	R2, [SP, #4]	
	LSL R2, R2, #6			
	ORR R3, R3, R2			

	MOV R2, #80			
	MUL R0, R2, R0			
	ADD R0, R0, R1 		

	LSL R0, #4			
	ADD R0, R0, #2		

	MOV R1, R3		

	BL	sendInstruction 		

	POP {LR}
    BX LR

	.align 2
    .global	setSprite
    .type	setSprite, %function
setSprite:

	PUSH {LR}				

    LSL R0, R0, #4       

    LSL R2, R2, #29    
    LSL R3, R3, #19    

    ORR R1, R1, R2      
    ORR R1, R1, R3      

    LDR	R2, [SP, #4]	
    LSL R2,R2, #9  
    ORR R1, R1, R2      
          
    BL sendInstruction      

    POP {LR}
    BX LR

	.align 2
    .global	setPolygon
    .type	setPolygon, %function

setPolygon:

	PUSH	{LR}		
   
    LSL R0, R0, #4      
    ORR R0, R0, #3      

    LSL R1, R1, #22     
    LSL R2, R2, #31     
    LSL R3, R3, #18     
      
    ORR R1, R1, R2      
    ORR R1, R1, R3    
    
    LDR	R2, [SP,#8]          
    LDR	R3, [SP,#4]	  

    LSL R3, R3, #9      

    ORR R1, R1, R2          
    ORR R1, R1, R3      

    BL sendInstruction      

    POP {LR}
    BX LR

	.align 2
    .global	buttonRead
    .type	buttonRead, %function

buttonRead:

	PUSH	{LR}		

	LDR R0, =virtual_base				
	LDR	R0, [R0] 
	LDR	R0, [R0, #0x0]    
           	
    POP {LR}
    BX LR

	


