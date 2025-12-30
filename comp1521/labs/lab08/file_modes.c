#include <stdio.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file1> [file2 ...]\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        struct stat st;
        if (stat(argv[i], &st) != 0) {
            perror(argv[i]);
            continue;
        }

        // 文件类型
        char type = '-';
        if (S_ISDIR(st.st_mode)) type = 'd';

        // 权限
        char perms[10] = "---------";

        if (st.st_mode & S_IRUSR) perms[0] = 'r';
        if (st.st_mode & S_IWUSR) perms[1] = 'w';
        if (st.st_mode & S_IXUSR) perms[2] = 'x';

        if (st.st_mode & S_IRGRP) perms[3] = 'r';
        if (st.st_mode & S_IWGRP) perms[4] = 'w';
        if (st.st_mode & S_IXGRP) perms[5] = 'x';

        if (st.st_mode & S_IROTH) perms[6] = 'r';
        if (st.st_mode & S_IWOTH) perms[7] = 'w';
        if (st.st_mode & S_IXOTH) perms[8] = 'x';

        printf("%c%s %s\n", type, perms, argv[i]);
    }

    return 0;
}