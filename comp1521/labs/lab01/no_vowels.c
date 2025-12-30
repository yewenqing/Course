#include <stdio.h>

int main(void) {
	char ch;
	while (scanf("%c", &ch) == 1) {
		if (ch != 'a' && ch != 'e' && ch != 'i' && ch != 'o' && ch != 'u'&& 
		ch != 'A' && ch != 'E' && ch != 'I' && ch != 'O' && ch != 'U') {
			printf("%c", ch);
		}
		//if (ch == '\n') break;
	}
	

}