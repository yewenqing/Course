#include <stdio.h>
#include <stdlib.h>

#define SERIES_MAX 30


int fb(int num);
int main(void) {
    char numc[16];
    while (scanf("%s", numc) != EOF) {
        int num = atoi(numc);
        int result = fb(num);
        printf("%d\n", result);
    }
    return EXIT_SUCCESS;
}

int fb(int num) {
    if (num == 0) return 0;
    if (num == 1) return 1;
    else return fb(num-1) + fb(num-2);
}