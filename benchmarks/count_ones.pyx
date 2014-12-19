"""
This module contains all kinds of fitness functions.
"""
from bitset import index, size, iterate
from profiling import profile


cpdef int count_ones(unsigned long long x):
    return size(x)


def lin_scaled_count_ones1(unsigned long long x):
    return sum(index(y) for y in iterate(x) if y)


def lin_scaled_count_ones2(unsigned long long x):
    return sum(i * bool(y) for i, y in enumerate(iterate(x)))


cpdef int lin_scaled_count_ones3(unsigned long long x):
    cdef int result = 0
    for y in iterate(x):
        if y:
            result += index(y)
    return result


cpdef int lin_scaled_count_ones4(unsigned long long x):
    cdef int result = 0
    for i, y in enumerate(iterate(x)):
        result += i * bool(y)
    return result


cpdef int lin_scaled_count_ones5(unsigned long long x):
    cdef int result = 0, i, y
    for i, y in enumerate(iterate(x)):
        if y:
            result += i
    return result


def test(f):
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += f(a)
        a += 1000

    return blackhole


#profile('test(lin_scaled_count_ones1)', globals(), locals())
#profile('test(lin_scaled_count_ones2)', globals(), locals())
profile('test(lin_scaled_count_ones3)', globals(), locals())
profile('test(lin_scaled_count_ones4)', globals(), locals())
profile('test(lin_scaled_count_ones5)', globals(), locals())
