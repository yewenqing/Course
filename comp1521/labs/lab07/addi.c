// generate the encoded binary for an addi instruction, including opcode and operands

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

// return the encoded binary MIPS for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    int head = 0x20000000;
    int ss = s << 21;
    int tt = t << 16;
    int ii = i & 0x0000ffff;
    int result = head | ss;
    result = result | tt;
    result = result | ii;
    return result; // REPLACE WITH YOUR CODE

}
