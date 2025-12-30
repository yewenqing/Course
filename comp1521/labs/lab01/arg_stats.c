#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	int MIN = atoi(argv[1]);
	int MAX = atoi(argv[1]);
	int SUM = 0;
	int PROD = 1;
	int MEAN = 0;
	for (int i = 1; i < argc; i++) {
		int num = atoi(argv[i]);
		if (num < MIN) MIN = num;
		if (num > MAX) MAX = num;
		SUM += num;
		PROD = PROD * num;
	}
	MEAN = SUM/(argc-1);
	printf("MIN:  %d \nMAX:  %d \nSUM:  %d \nPROD: %d \nMEAN: %d\n",MIN, MAX, SUM, PROD, MEAN);
	return 0;
}
