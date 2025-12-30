// Compare 2 floats using bit operations only

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// float_less is given the bits of 2 floats bits1, bits2 as a uint32_t
// and returns 1 if bits1 < bits2, 0 otherwise
// 0 is return if bits1 or bits2 is Nan
// only bit operations and integer comparisons are used
uint32_t float_less(uint32_t bits1, uint32_t bits2) {
    uint32_t sign1 = bits1 >> 31;
    uint32_t sign2 = bits2 >> 31;
    uint32_t exp1 = (bits1 >> 23) & 0xFF;
    uint32_t exp2 = (bits2 >> 23) & 0xFF;
    uint32_t frac1 = bits1 & 0x7FFFFF;
    uint32_t frac2 = bits2 & 0x7FFFFF;

    // NaN
    if ((exp1 == 0xFF && frac1 != 0) || (exp2 == 0xFF && frac2 != 0)) {
        return 0;
    }

    // ±0
    if ((bits1 << 1) == 0 && (bits2 << 1) == 0) {
        return 0;
    }

    // +-
    if (sign1 != sign2) {
        return sign1;
    }

  
    if (sign1 == 0) {
        // ++
        return bits1 < bits2;
    } else {
        // --
        return bits1 > bits2;
    }
}