#include <stdio.h>
extern int dot_product(int a, int b, int c, int d, int e    );

int main(){
    int x = 5,y=3, z=1,w=4, h=5;
    int result = dot_product(x,y,z,w,h);
    printf("%d", result);
    return 0;
}