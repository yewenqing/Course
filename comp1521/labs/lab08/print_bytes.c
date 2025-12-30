#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL) {
        fprintf(stderr, "Error: could not open file '%s'\n", argv[1]);
        return 1;
    }

    int c;
    long index = 0;

    while ((c = fgetc(fp)) != EOF) {
        printf("byte %4ld: %3d 0x%02x", index, c, c);

        if (isprint(c)) {
            printf(" '%c'", c);
        }

        printf("\n");
        index++;
    }

    fclose(fp);
    return 0;
}