#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 ) //0x3FFFFFF
#define ALT_LWFPGASLVS_OFST 0xff200000
#define DATA_B_BASE 0x70
#define DATA_A_BASE 0x80
#define WRREG_BASE  0xc0
#define WRFULL_BASE 0xb0


void *virtual_base;
void *h2p_lw_dataA_addr;
void *h2p_lw_dataB_addr;
void *h2p_lw_wrReg_addr;
void *h2p_lw_wrFull_addr;
void *h2p_lw_screen_addr;
void *h2p_lw_result_pulseCounter_addr;
int fd;

int createMappingMemory(){
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "[ERROR]: could not open \"/dev/mem\"...\n" );
		return -1;
	}
	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );
	if( virtual_base == MAP_FAILED ) {
		printf( "[ERROR]: mmap() failed...\n" );
		close( fd );
		return -1;
	}
	h2p_lw_dataA_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_A_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_dataB_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DATA_B_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_wrReg_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + WRREG_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_wrFull_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + WRFULL_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	return 1;
}

void closeMappingMemory(){
	// clean up our memory mapping and exit
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "[ERROR]: munmap() failed...\n" );
		close(fd);
	}
}

/* ================================================================================
Function to verifies if the FIFO is full.
===================================================================================*/
int isFull(){
	return *(uint32_t *) h2p_lw_wrFull_addr;
}

void sendInstruction(unsigned long dataA, unsigned long dataB){
	if(isFull() == 0){
		*(uint32_t *) h2p_lw_wrReg_addr = 0;
		*(uint32_t *) h2p_lw_dataA_addr = dataA;
		*(uint32_t *) h2p_lw_dataB_addr = dataB;
		*(uint32_t *) h2p_lw_wrReg_addr = 1;
		*(uint32_t *) h2p_lw_wrReg_addr = 0;
	}
}

/* ================================================================================
Function to defines the dataA bus of the instruction.
===================================================================================*/
static unsigned long dataA_builder(int opcode, int reg, int memory_address){
	unsigned long data = 0;
	switch(opcode){
		case(0):
			data = data | reg;                  
			data = data << 4;                   
			data = data | opcode;               
			break;
		case(1):
		case(2):
		case(3):
			data = data | memory_address;   
			data = data << 4;      
			data = data | opcode;
			break;
	}
	return data;
}

void set_background_color(int R, int G, int B){
	unsigned long dataA = dataA_builder(0,0,0);
	unsigned long color = B;
	color = color << 3;
	color = color | G;
	color = color << 3;
	color = color | R;
	sendInstruction(dataA, color);
}

void set_background_block(int column, int line, int R, int G, int B){
	int address = (line * 80) + column;
	unsigned long dataA = dataA_builder(2, 0, address);
	unsigned long color = B;
	color = color << 3;
	color = color | G;
	color = color << 3;
	color = color | R;
	sendInstruction(dataA, color);
}

void waitScreen(int limit){
	int screens = 0;
 	while(screens <= limit){ // Wait x seconds for restart Game 
		if(*(uint32_t *) h2p_lw_screen_addr == 1){ // Checks if a screen has finished drawing.
			// Structure for counter of screen and set parameters.
			screens++;
			*(uint32_t *) h2p_lw_result_pulseCounter_addr = 1;
			*(uint32_t *) h2p_lw_result_pulseCounter_addr = 0;
		}
	}
}


