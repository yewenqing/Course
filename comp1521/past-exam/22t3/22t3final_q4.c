// COMP1521 22T3 ... final exam, question 4

#include <stdint.h>

int _22t3final_q4(uint32_t x) {
    // TODO: complete this function
    int count = 0;
    int max = 0;
    for (int i = 0; i < 32; i++) {
        if (x & 0x1) {
            count++;
            if (count > max) max = count;
        } else count = 0;
        x = x >> 1;
    }
    return max;
}
