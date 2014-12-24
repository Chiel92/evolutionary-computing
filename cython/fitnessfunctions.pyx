"""
This module contains all kinds of fitness functions.
"""

from bitset cimport uint128, index, size

from bitset import iterate


def count_ones(uint128 x):
    return size(x)


def lin_scaled_count_ones(uint128 x):
    cdef int result = 0
    for y in iterate(x):
        result += index(y)
    return result


def td_trap(uint128 x):
    cdef int result = 0, y

    for i in range(25):
        x >>= 4
        y = x & 15

        if y != 15:
            result += 3 - size(y)
        else:
            result += 4

    return result


def tn_trap(uint128 x):
    cdef double result = 0
    cdef int y

    for i in range(25):
        x >>= 4
        y = x & 15

        if y != 15:
            result += (3 - size(y)) / 2
        else:
            result += 4

    return result
