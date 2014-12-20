"""
This module contains all kinds of fitness functions.
"""
from bitset import size, iterate

cpdef int count_ones(unsigned long long x):
    return size(x)

cpdef int lin_scaled_count_ones(unsigned long long x):
    cdef int result = 0
    for y in iterate(x):
        result += index(y)
    return result

