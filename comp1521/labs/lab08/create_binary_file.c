#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <filename> <byte1> [<byte2> ...]\n", argv[0]);
        return 1;
    }

    char *filename = argv[1];


    FILE *fp = fopen(filename, "wb");
    if (fp == NULL) {
        fprintf(stderr, "Error: could not create file '%s'\n", filename);
        return 1;
    }

    for (int i = 2; i < argc; i++) {
        int value = atoi(argv[i]);

        // 检查范围是否在 0~255 之间
        if (value < 0 || value > 255) {
            fprintf(stderr, "Error: byte value %d out of range (0–255)\n", value);
            fclose(fp);
            return 1;
        }

        fputc(value, fp);  // 写入一个字节
    }    


    fclose(fp);
    return 0;
}