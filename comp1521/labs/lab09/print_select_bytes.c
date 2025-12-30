#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <filename> <pos>...\n", argv[0]);
        return 1;
    }
    FILE *fp = fopen(argv[1], "rb");
    for (int i = 2; i < argc; i++) {
        long long pos = atoll(argv[i]);   // 

        fseek(fp, pos, SEEK_SET);         // 跳到指定位置pos
        int byte = fgetc(fp);             // 读取该位置的字节

        if (byte == EOF) {
            // 超出文件范围
            continue;
        }

        printf("%d - 0x%02X", byte, byte);

        if (isprint(byte)) {
            printf(" - '%c'", byte);
        }

        printf("\n");
    }

    fclose(fp); 
}