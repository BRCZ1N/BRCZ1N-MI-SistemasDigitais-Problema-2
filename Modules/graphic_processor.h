#ifndef _GRAPHIC_PROCESSOR_H
#define _GRAPHIC_PROCESSOR_H

#define MASX_TO_SHIFT_X 0b00011111111110000000000000000000
#define MASX_TO_SHIFT_Y 0b00000000000001111111111000000000

#define LEFT   		 0
#define UPPER_RIGHT  1
#define UP 			 2
#define UPPER_LEFT   3
#define RIGHT  		 4
#define BOTTOM_LEFT  5
#define DOWN         6
#define BOTTOM_RIGHT 7


typedef struct{

	int coord_x;          
	int coord_y;          
	int direction;        
	int offset;           
	int data_register;    
	int step_x; 		  
	int step_y; 		 
	int ativo;
	int collision;  
	      
} Sprite;

typedef struct{

	int coord_x;          
	int coord_y;          
	int offset;           
	int data_register; 

} Sprite_Fixed;

extern void setSprite(int registrador, int x, int y, int offset, int activation_bit);

extern void setBackgroundColor(int R, int G, int B);

extern void setBackgroundBlock(int column, int line, int R, int G, int B);

extern void setPolygon(int address, int opcode, int color, int form, int mult, int ref_point_x, int ref_point_y);

extern void sendInstruction(unsigned long dataA, unsigned long dataB);

extern void closeGpuMapping();

extern int gpuMapping();

void increase_coordinate(Sprite *sp, int mirror);

int collision(Sprite *sp1, Sprite *sp2);

int isFull();

void waitScreen(int limit);

#endif	/* _GRAPHIC_PROCESSOR_H */