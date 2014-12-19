"""
This module contains all kinds of fitness functions.
"""
from bitset import index, size, iterate

cpdef int count_ones(unsigned long long x):
    return size(x)

cpdef int lin_scaled_count_ones(unsigned long long x):
    cdef int result = 0, i, y
    for i, y in enumerate(iterate(x)):
        if y:
            result += i
    return result

