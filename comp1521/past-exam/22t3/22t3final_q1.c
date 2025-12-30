// COMP1521 22T3 ... final exam, question 1

#include <stdint.h>

uint32_t _22t3final_q1(uint32_t x) {
    // ADD YOUR CODE HERE
    x = x >> 12;
    return x & 0xFF; 
}
