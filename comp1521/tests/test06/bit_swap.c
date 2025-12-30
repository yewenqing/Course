// swap pairs of bits of a 64-bit value, using bitwise operators

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return value with pairs of bits swapped
uint64_t bit_swap(uint64_t value) {
    // PUT YOUR CODE HERE
    uint64_t even_bits = value & 0x5555555555555555;  
    uint64_t odd_bits  = value & 0xAAAAAAAAAAAAAAAA;  
    return (even_bits << 1) | (odd_bits >> 1);
}
