#include <stdio.h>
#include <string.h>


int main(void) {
    char line[1024];
    while (fgets(line, sizeof line, stdin) != NULL) {

        size_t len = strlen(line);

        if (len % 2 == 0) {
            fputs(line, stdout);
        }
    }

    return 0;
}