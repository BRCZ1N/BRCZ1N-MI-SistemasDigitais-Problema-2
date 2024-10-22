#include "graphic_processor.h"

int main(){

	Sprite sprt_1;
	Sprite sprt_2;
	Sprite sprt_3;
	Sprite sprt_4;
	Sprite sprt_5;

	sprt_1.ativo = 1; sprt_1.data_register  = 1;  sprt_1.coord_x = 220;  sprt_1.coord_y = 100;  sprt_1.offset = 0;
	sprt_2.ativo = 1; sprt_2.data_register  = 2;  sprt_2.coord_x = 250;  sprt_2.coord_y = 100;  sprt_2.offset = 1;
	sprt_3.ativo = 1; sprt_3.data_register  = 3;  sprt_3.coord_x = 280;  sprt_3.coord_y = 100;  sprt_3.offset = 2;
	sprt_4.ativo = 1; sprt_4.data_register  = 4;  sprt_4.coord_x = 310; sprt_4.coord_y = 100;  sprt_4.offset = 3;
	sprt_5.ativo = 1; sprt_5.data_register  = 5;  sprt_5.coord_x = 340; sprt_5.coord_y = 100;  sprt_5.offset = 4;

	gpuMapping();

	setBackgroundColor(0b000, 0b000, 0b000);

	while(1){ if(isFull() == 0) { setSprite(sprt_1.data_register, sprt_1.coord_x, sprt_1.coord_y, sprt_1.offset, sprt_1.ativo); break; } }
	while(1){ if(isFull() == 0) { setSprite(sprt_2.data_register, sprt_2.coord_x, sprt_2.coord_y, sprt_2.offset, sprt_2.ativo); break; } }
	while(1){ if(isFull() == 0) { setSprite(sprt_3.data_register, sprt_3.coord_x, sprt_3.coord_y, sprt_3.offset, sprt_3.ativo); break; } }
	while(1){ if(isFull() == 0) { setSprite(sprt_4.data_register, sprt_4.coord_x, sprt_4.coord_y, sprt_4.offset, sprt_4.ativo); break; } }
	while(1){ if(isFull() == 0) { setSprite(sprt_5.data_register, sprt_5.coord_x, sprt_5.coord_y, sprt_5.offset, sprt_5.ativo); break; } }

	closeGpuMapping();
}