#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int utf8_len(unsigned char b) {
    if ((b & 0x80) == 0x00) return 1;          // ASCII
    if ((b & 0xE0) == 0xC0) return 2;          // 110xxxxx
    if ((b & 0xF0) == 0xE0) return 3;          // 1110xxxx
    if ((b & 0xF8) == 0xF0) return 4;          // 11110xxx
    return 0;                                  // invalid
}

bool is_con_byte(unsigned char b) {
    return (b & 0xC0) == 0x80;                 // 10xxxxxx
}

char *_22t3final_q7(char *str) {
    size_t len = strlen(str);
    char *out = malloc(len + 1);
    size_t i = 0, j = 0;

    while (i < len) {
        unsigned char c = str[i];
        int n = utf8_len(c);

        if (n == 0) {  //invalid
            out[j++] = '?';
            i++;
            continue;
        }
        if (n == 1) {
            out[j++] = str[i++];
            continue;
        }

        // check needed continuation bytes
        bool ok = true;
        if (i + n > len) ok = false;  // not enough bytes
        if ( n >= 2 && n <= 4) {
            int count = 1;
            for (int k = 1; k < n; k++) {
                if (!is_con_byte(str[i+k])) {
                    ok = false;
                    
                }
                count++;
            }
            if (ok) {
                for (int l = 0; l < n; l++) {
                    out[j++] = str[i++];
                }
            } else {
                out[j++] = '?';
                i+=count;
                continue;
            }            
        }
    }
    


    out[j] = '\0';

    return out;
}
