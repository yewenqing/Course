#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <filename> <start> <end>\n", argv[0]);
        return 1;
    }

    char *filename = argv[1];
    int start = atoi(argv[2]);
    int end = atoi(argv[3]);

    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {
        fprintf(stderr, "Error: could not create file '%s'\n", filename);
        return 1;
    }

    for (int i = start; i <= end; i++) {
        fprintf(fp, "%d\n", i);
    }

    fclose(fp);
    return 0;
}