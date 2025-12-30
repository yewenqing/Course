#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("Program name: %s\n", argv[0]);
	if (argc == 1) printf("There are no other arguments\n");
	else {
		printf("There are %d arguments:\n", argc-1);
		for (int i = 0; i < argc-1; i++) {
			printf("\tArgument %d is \"%s\" \n", i+1, argv[i+1]);
		}
		
	}
	return 0;
}
