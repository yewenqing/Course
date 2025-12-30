// Given an UTF-8 string, return the index of the first invalid byte.
// If there are no invalid bytes, return -1.

// Do NOT change this function's return type or signature.
int invalid_utf8_byte(char *utf8_string) {
    unsigned char *s = (unsigned char *)utf8_string; // type transform

    int i = 0;
    while (s[i] != '\0') {
        // i : byte start bit
        unsigned char byte = s[i];
        int len = 0;

        // Determine character length by first byte
        if ((byte & 0x80) == 0x00) {
            len = 1;                         // 0xxxxxxx
        } else if ((byte & 0xE0) == 0xC0) {
            len = 2;                         // 110xxxxx
        } else if ((byte & 0xF0) == 0xE0) {
            len = 3;                         // 1110xxxx
        } else if ((byte & 0xF8) == 0xF0) {
            len = 4;                         // 11110xxx
        } else {
            return i;                        // invalid start byte
        }

        // Check continuation bytes
        for (int j = 1; j < len; j++) {
            unsigned char cont = s[i + j];
            if (cont == '\0') {
                return i + j;                // string ends too early
            }
            if ((cont & 0xC0) != 0x80) {
                return i + j;                // invalid continuation byte 不以10开头
            }
        }

        i += len;
    }

    return -1;   // Valid UTF-8
}