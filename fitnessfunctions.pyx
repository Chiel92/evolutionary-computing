"""
This module contains all kinds of fitness functions.
"""

from bitset cimport index, size

from bitset import iterate


cpdef int count_ones(unsigned long long x):
    return size(x)


cpdef int lin_scaled_count_ones(unsigned long long x):
    cdef int result = 0
    for y in iterate(x):
        result += index(y)
    return result


cdef int td_trap(unsigned long long x):
    cdef int result = 0, y

    for i in range(25):
        x >>= 4
        y = x & 15

        if y != 15:
            result += 3 - size(y)
        else:
            result += 4

    return result


cdef double tn_trap(unsigned long long x):
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
