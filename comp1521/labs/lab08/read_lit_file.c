#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    char *filename = argv[1];

    

    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        fprintf(stderr, "Error: could not create file '%s'\n", filename);
        return 1;
    }


    unsigned char magic[3];
    if (fread(magic, 1, 3, fp) != 3) {
        fprintf(stderr, "Failed to read magic\n");
        fclose(fp);
        return 1;
    }

    if (magic[0] != 'L' || magic[1] != 'I' || magic[2] != 'T') {
        fprintf(stderr, "Failed to read magic\n");
        fclose(fp);
        return 1;
    }


    int c;
    while ((c = fgetc(fp)) != EOF) {
        if (c < '1' || c > '8') {
            fprintf(stderr, "Invalid record length\n");
            fclose(fp);
            return 1;
        }

        int num_bytes = c - '0';
        unsigned char buffer[8];

        size_t read_bytes = fread(buffer, 1, num_bytes, fp);
        if (read_bytes != (size_t)num_bytes) {
            fprintf(stderr, "Failed to read record\n");
            fclose(fp);
            return 1;
        }

        unsigned long long value = 0;
        for (int i = 0; i < num_bytes; i++) {
            value |= ((unsigned long long)buffer[i]) << (8 * i);
        }

        printf("%llu\n", value);
    }

    fclose(fp);
    return 0;
}