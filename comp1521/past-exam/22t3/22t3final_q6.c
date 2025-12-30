// COMP1521 22T3 ... final exam, question 6

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define MAX_LEN 256


int main(int argc, char *argv[]) {

    assert(argc == 3);

    char *filename = argv[1];
    int line = atoi(argv[2]);

    assert(line > 0);

    // ADD YOUR CODE HERE

    FILE *fp = fopen(filename, "r");
    char *tmp_name = "temp.tmp";
    FILE *tmp = fopen(tmp_name, "w");
    char buf[MAX_LEN];
    int count = 1;
    while (fgets(buf, MAX_LEN, fp)) {
        //printf("count: %d\n", count);
        if (count == line) {
            //printf("count == line\n");
            count++;
            continue;
        }
        fputs(buf, tmp);
        count++;
    }
    fclose(fp);
    remove(filename);
    rename(tmp_name, filename);
    return 0;
}

