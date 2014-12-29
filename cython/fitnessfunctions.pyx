"""
This module contains all kinds of fitness functions.
"""

from bitset cimport uint128, index, size
from bitset import iterate
from utils cimport randomint


def shuffled(uint128 x):
    """Shuffle bits 0 to 99 using fisher-yates shuffle."""
    cdef int i, j
    cdef uint128 t

    for i in range(99, -1 ,-1):
        j = randomint(i + 1)

        if i != j:
            # Swap bit positions i and j
            t = ((x >> i) ^ (x >> j)) & 1 # XOR temporary
            x = x ^ ((t << i) | (t << j))

    return x


def count_ones(uint128 x):
    return size(x)


def count_zeros(uint128 x):
    return 128 - size(x)


def lin_scaled_count_ones(uint128 x):
    cdef int result = 0
    for y in iterate(x):
        result += index(y) + 1
    return result


def td_trap(uint128 x):
    cdef int result = 0, y

    for i in range(25):
        y = x & 15

        if y != 15:
            result += 3 - size(y)
        else:
            result += 4
        x >>= 4

    return result


def tn_trap(uint128 x):
    cdef double result = 0
    cdef int y

    for i in range(25):
        y = x & 15

        if y != 15:
            result += (3 - size(y)) / 2
        else:
            result += 4
        x >>= 4

    return result


def rd_trap(uint128 x):
    x = shuffled(x)
    return td_trap(x)


def rn_trap(uint128 x):
    x = shuffled(x)
    return tn_trap(x)


