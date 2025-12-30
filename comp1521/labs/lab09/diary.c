#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 2) return 0;  // 没有参数就退出

    char *home = getenv("HOME");
    if (home == NULL) return 1;  // HOME 未定义

    char path[1024];
    snprintf(path, sizeof(path), "%s/.diary", home);

    FILE *fp = fopen(path, "a");
    if (fp == NULL) return 1; // 文件打开失败

    // 写入命令行参数
    for (int i = 1; i < argc; i++) {
        fprintf(fp, "%s", argv[i]);
        if (i < argc - 1) fprintf(fp, " "); //如果不是最后一个则print空格
    }
    fprintf(fp, "\n");

    fclose(fp);
    return 0;
}