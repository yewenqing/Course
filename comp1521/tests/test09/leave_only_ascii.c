#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
    char *filename = argv[1];


    
    FILE *in = fopen(filename, "rb");

    FILE *tmp = fopen("temp_ascii_strip.tmp", "wb");

    int c;
    while ((c = fgetc(in)) != EOF) {
        if (c >= 0 && c <= 127) {
            fputc(c, tmp);
        }
    }

    fclose(in);
    fclose(tmp);


    tmp = fopen("temp_ascii_strip.tmp", "rb");
    FILE *out = fopen(filename, "wb");

    while ((c = fgetc(tmp)) != EOF) {
        fputc(c, out);
    }

    fclose(tmp);
    fclose(out);


    remove("temp_ascii_strip.tmp");

    return 0;
}