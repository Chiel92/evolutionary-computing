"""
This module contains all kinds of fitness functions.
"""

from bitset cimport uint128, index, size, size_int
from utils cimport randomint


cpdef uint128 shuffled_fixed(list pattern, uint128 x):
    """Shuffle bits 0 to 99 using fisher-yates shuffle according to given shuffle pattern."""
    cdef int i = 99, j
    cdef uint128 t

    while i >= 0:
        #j = randomint(i + 1)
        j = pattern[i]

        if i != j:
            # Swap bit positions i and j
            t = ((x >> i) ^ (x >> j)) & 1 # XOR temporary
            x = x ^ ((t << i) | (t << j))
        i -= 1

    return x


cpdef int count_ones(uint128 x):
    """Counting ones"""
    return size(x)


cpdef int lin_scaled_count_ones(uint128 x):
    """Linearly scaled counting ones"""
    cdef int result = 0, i = 1
    while i <= 100:
        if x & 1:
            result += i
        x >>= 1
        i += 1
    return result


cpdef int td_trap(uint128 x):
    """Tightly linked deceptive trap"""
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


cpdef int tn_trap(uint128 x):
    """Tightly linked non-deceptive trap"""
    # To save a division we work with double the score.
    cdef int result = 0, y, i = 0

    while i < 25:
        y = x & 15

        if y != 15:
            result += 3 - size_int(y)
        else:
            result += 8
        x >>= 4
        i += 1

    return result


# For every i we have a j > i which i will be swapped with in the fisher-yates shuffle
rd_shuffle_pattern = [randomint(i + 1) for i in range(0, 100)]
cpdef int rd_trap(uint128 x):
    """Randomly linked deceptive trap"""
    return td_trap(shuffled_fixed(rd_shuffle_pattern, x))


rn_shuffle_pattern = [randomint(i + 1) for i in range(0, 100)]
cpdef double rn_trap(uint128 x):
    """Randomly linked non-deceptive trap"""
    return tn_trap(shuffled_fixed(rn_shuffle_pattern, x))

