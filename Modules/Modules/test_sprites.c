#include <stdio.h>

extern int closeGpuMapping();

extern int gpuMapping();

extern void setSprite(int registrador, int x, int y, int offset, int activation_bit);

extern void setBackgroundColor(int R, int G, int B);

extern void setBackgroundBlock(int column, int line, int R, int G, int B);

extern void setPolygon(int address, int opcode, int color, int form, int mult, int ref_point_x, int ref_point_y);

int main(){


	gpuMapping();
	setBackgroundColor(0,0,5);
	//setBackgroundColor(200,200,200);
	//setBackgroundColor(300,300,300);
	//setBackgroundBlock(1,1,1,1,1);
	closeGpuMapping();
	return 0;	

}

