# encoding: utf-8
# filename: count_ones.pyx
"""
This module contains all kinds of fitness functions.
"""
cimport bitset
from bitset cimport size, index

from bitset import iterate
from profiling import profile, compare


cdef extern int __builtin_popcountll(unsigned long long x)


cpdef int count_ones1(unsigned long long x):
    return size(x)


cdef int count_ones2(unsigned long long x):
    return __builtin_popcountll(x)


def lin_scaled_count_ones1(unsigned long long x):
    return sum(index(y) for y in iterate(x))


cpdef int lin_scaled_count_ones2(unsigned long long x):
    cdef int result = 0
    cdef unsigned long long y
    for y in iterate(x):
        result += index(y)
    return result

cpdef int lin_scaled_count_ones3(unsigned long long x):
    cdef int result = 0
    for y in iterate(x):
        result += index(y)
    return result


def test(f):
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += f(a)
        a += 1000

    return blackhole


def test1():
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += count_ones1(a)
        a += 1000

    return blackhole


def test2():
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += count_ones2(a)
        a += 1000

    return blackhole


def test3():
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += __builtin_popcountll(a)
        a += 1000

    return blackhole

compare([test1, test2, test3])

#profile('test1()', globals(), locals())
#profile('test2()', globals(), locals())
#profile('test3()', globals(), locals())
#profile('test(lin_scaled_count_ones1)', globals(), locals())
#profile('test(lin_scaled_count_ones2)', globals(), locals())
#profile('test(lin_scaled_count_ones3)', globals(), locals())
