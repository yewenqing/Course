#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    char *file1 = argv[1];
    long pos1 = atol(argv[2]);
    char *file2 = argv[3];
    long pos2 = atol(argv[4]);

    FILE *f1 = fopen(file1, "rb");
    FILE *f2 = fopen(file2, "rb");

    int c1, c2;


    fseek(f1, pos1, SEEK_SET);
    c1 = fgetc(f1);

    fseek(f2, pos2, SEEK_SET);
    c2 = fgetc(f2);

    fclose(f1);
    fclose(f2);

    printf("byte %ld in %s and byte %ld in %s are ",
           pos1, file1, pos2, file2);

    // If either is EOF → position past end → not same
    if (c1 == EOF || c2 == EOF || c1 != c2) {
        printf("not the same\n");
    } else {
        printf("the same\n");
    }

    return 0;
}
