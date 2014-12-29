"""
This module contains all kinds of fitness functions.
"""

from bitset cimport uint128, index, size, size_int
from bitset import iterate
from utils cimport randomint


cpdef uint128 shuffled(uint128 x):
    """Shuffle bits 0 to 99 using fisher-yates shuffle."""
    cdef int i = 99, j
    cdef uint128 t

    while i >= 0:
        j = randomint(i + 1)

        if i != j:
            # Swap bit positions i and j
            t = ((x >> i) ^ (x >> j)) & 1 # XOR temporary
            x = x ^ ((t << i) | (t << j))
        i -= 1

    return x


cpdef int count_ones(uint128 x):
    return size(x)


cpdef int count_zeros(uint128 x):
    return 128 - size(x)


cpdef int lin_scaled_count_ones(uint128 x):
    cdef int result = 0, i = 1
    while i <= 100:
        if x & 1:
            result += i
        x >>= 1
        i += 1
    return result


cpdef int td_trap(uint128 x):
    cdef int result = 0, y, i = 0

    while i < 25:
        y = x & 15

        if y != 15:
            result += 3 - size_int(y)
        else:
            result += 4
        x >>= 4
        i += 1

    return result


cpdef double tn_trap(uint128 x):
    """To save a division we work with double the score."""
    cdef double result = 0, i = 0
    cdef int y

    while i < 25:
        y = x & 15

        if y != 15:
            result += (3 - size_int(y))
        else:
            result += 8
        x >>= 4
        i += 1

    return result


cpdef int rd_trap(uint128 x):
    return td_trap(shuffled(x))


cpdef double rn_trap(uint128 x):
    return tn_trap(shuffled(x))

