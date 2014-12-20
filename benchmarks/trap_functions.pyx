"""
Benchmarks for trap functions.
"""
from bitset cimport size, index

from bitset import iterate
from profiling import profile, compare


cdef int td_trap1(unsigned long long x):
    cdef int result = 0, i = 0, y

    while i < 25:
        i += 1
        x >>= 4
        y = x & 15

        if y != 15:
            result += 3 - size(y)
        else:
            result += 4

    return result


cdef int td_trap2(unsigned long long x):
    cdef int result = 0, y

    for i in range(25):
        x >>= 4
        y = x & 15

        if y != 15:
            result += 3 - size(y)
        else:
            result += 4

    return result


cdef double tn_trap1(unsigned long long x):
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


#cdef int rd_trap(unsigned long long x):
    #pass


#cdef int rd_trap(unsigned long long x):
    #pass


def test1():
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += td_trap1(a)
        a += 100

    return blackhole


def test2():
    cdef unsigned long long blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += td_trap2(a)
        a += 100

    return blackhole


def test3():
    cdef double blackhole = 0
    cdef unsigned long long a = 0L
    cdef unsigned long long bound = 2 ** 30

    while a < bound:
        blackhole += tn_trap1(a)
        a += 100

    return blackhole

compare([test1, test2])
compare([test3])

