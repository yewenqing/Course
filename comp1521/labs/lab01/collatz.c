#include <stdio.h>
#include <stdlib.h>


int collatz(int num);

int main(int argc, char *argv[])
{
	int num = atoi(argv[1]);
	collatz(num);
	return EXIT_SUCCESS;
}

int collatz(int num) {
	printf("%d\n", num);
	if (num == 1) return 1;
	else {
		if (num % 2 == 0) return collatz(num/2);
		else return collatz(3*num + 1);
	}
}