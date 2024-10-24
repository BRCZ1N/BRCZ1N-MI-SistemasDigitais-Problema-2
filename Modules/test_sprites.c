#include <stdio.h>

extern int closeGpuMapping();

extern int gpuMapping();

int main(){

	gpuMapping();
	closeGpuMapping();

}