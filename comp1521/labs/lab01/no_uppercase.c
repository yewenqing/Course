#include <stdio.h>
#include <ctype.h>

int main(void) {
	char c;
	while (1) {
		c = getchar();
		if (c == EOF) break; 
		if (isupper(c)) putchar(tolower(c));
		else putchar(c);
	}
	return 0;
}
