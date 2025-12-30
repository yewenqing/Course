#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <time.h> 
int main(int argc, char *argv[]) {
    time_t now = time(NULL);

    for (int i = 1; i < argc; i++) {
        char *file = argv[i];
        struct stat s;

        stat(file, &s);

        time_t atime = s.st_atime;   // access time
        time_t mtime = s.st_mtime;   // modification time
        if (atime > now || mtime > now) {
            printf("%s has a timestamp that is in the future\n", file);
        }    
    }
    
    


    






    return 0;
}
