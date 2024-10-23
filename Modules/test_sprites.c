#include <stdio.h>

extern void closeGpuMapping();

extern int gpuMapping();

int main(){

	int i = gpuMapping();
	closeGpuMapping();

}