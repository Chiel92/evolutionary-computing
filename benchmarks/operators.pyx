"""
Benchmarks for trap functions.
"""
from libc.stdlib cimport rand
from bitset cimport size, index

from bitset import iterate
from profiling import profile, compare
from random import randint


ctypedef unsigned long long ull


cdef extern from "stdlib.h":
    int RAND_MAX


cdef struct Pair:
    ull x
    ull y


cdef int randomint(int upperbound):
    return <int> ((rand() / <float>RAND_MAX) * upperbound)


cdef tuple two_point_crossover1(ull x, ull y):
    cdef int k = randint(0, 100)
    cdef ull part1 = (1 << k) - 1
    cdef ull part2 = ~part1

    return (x & part1) | (y & part2), (y & part1) | (x & part2)


cdef Pair two_point_crossover2(ull x, ull y):
    cdef int k = randint(0, 100)
    cdef ull part1 = (1 << k) - 1
    cdef ull part2 = ~part1

    return Pair((x & part1) | (y & part2), (y & part1) | (x & part2))


cdef Pair two_point_crossover3(ull x, ull y):
    cdef int k = randomint(100)
    cdef ull part1 = (1 << k) - 1
    cdef ull part2 = ~part1

    return Pair((x & part1) | (y & part2), (y & part1) | (x & part2))



def test1():
    cdef ull blackhole = 0
    cdef ull a = 0L
    cdef ull bound = 2 ** 30
    cdef ull x, y

    while a < bound:
        x, y = two_point_crossover1(a, a)
        blackhole += x + y
        a += 1000

    return blackhole


def test2():
    cdef ull blackhole = 0
    cdef ull a = 0L
    cdef ull bound = 2 ** 30

    while a < bound:
        offspring = two_point_crossover2(a, a)
        blackhole += offspring.x + offspring.y
        a += 1000

    return blackhole


def test3():
    cdef ull blackhole = 0
    cdef ull a = 0L
    cdef ull bound = 2 ** 30

    while a < bound:
        offspring = two_point_crossover3(a, a)
        blackhole += offspring.x + offspring.y
        a += 1000

    return blackhole


compare([test1, test2, test3])

