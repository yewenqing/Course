#include "bit_rotate.h"

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    if (n_rotations > 0) {
        int r = n_rotations % 16;
        for (int i = 0; i < r; i++) {
            int b = (bits & 0x8000) >> 15;
            bits <<= 1;
            bits = bits | b;
        }
    } else {
        int r = -n_rotations % 16;
        for (int i = 0; i < r; i++) {
            int b = (bits & 0x0001) << 15;
            bits >>= 1;
            bits = bits | b;
        }        
    }

    
    return bits ;
}
