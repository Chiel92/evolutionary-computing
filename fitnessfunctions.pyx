"""
This module contains all kinds of fitness functions.
"""
from bitset import index, size, iterate

cpdef int count_ones(unsigned long long x):
    return size(x)

def lin_scaled_count_ones1(unsigned long long x):
    return sum(index(y) for y in iterate(x) if y)

def lin_scaled_count_ones2(unsigned long long x):
    return sum(i * bool(y) for i, y in enumerate(iterate(x)))

cpdef lin_scaled_count_ones3(unsigned long long x):
    cdef int result = 0
    for y in iterate(x):
        if y:
            result += index(y)
    return result

cpdef lin_scaled_count_ones4(unsigned long long x):
    cdef int result = 0
    for i, y in enumerate(iterate(x)):
        result += i * bool(y)
    return result
