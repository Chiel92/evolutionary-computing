# cython: profile=True
"""
Benchmarks for operators.
"""
from libc.stdlib cimport rand
from bitset cimport size, index, domain

from bitset import iterate
from profiling import profile, compare
from random import randint

#ctypedef extern __uint128_t
#ctypedef extern __int128

#cdef extern from "cstdint.h":
    #ctypedef __uint128_t

ctypedef unsigned long long bitset

cdef struct Pair:
    bitset x
    bitset y


cdef extern from "stdlib.h":
    int RAND_MAX

cdef int randomint(int upperbound):
    return <int> ((rand() / <float>RAND_MAX) * upperbound)

RAND_SIZE = sizeof(RAND_MAX) * 8
bitset_RAND_RATIO = <int>((sizeof(bitset) * 8) / RAND_SIZE)
print(RAND_SIZE)
print(bitset_RAND_RATIO)
#print(sizeof(int))
#print(sizeof(long))
#print(sizeof(long long))
#print(sizeof(unsigned long long))
#print(sizeof(__uint128_t))
#print(sizeof(__int128))
#exit()

cdef bitset randombitset():
    cdef bitset result = 0
    #cdef __uint128_t result = 0
    #cdef __int128 result = 0
    for i in range(bitset_RAND_RATIO):
        print('<<<')
        result <<= RAND_SIZE
        print('---')
        result |= rand()
        print('>>>')
    return result

print(randombitset())
exit()


#
# 2 POINT CROSSOVER
#


cdef tuple two_point_crossover1(bitset x, bitset y):
    cdef int beg = randint(0, 100)
    cdef int end = randint(0, 100)
    cdef bitset part1 = ((1 << end) - 1) - ((1 << beg) - 1)
    cdef bitset part2 = ~part1

    return (x & part1) | (y & part2), (y & part1) | (x & part2)


cdef Pair two_point_crossover2(bitset x, bitset y):
    cdef int beg = randint(0, 100)
    cdef int end = randint(0, 100)
    cdef bitset part1 = ((1 << end) - 1) - ((1 << beg) - 1)
    cdef bitset part2 = ~part1

    return Pair((x & part1) | (y & part2), (y & part1) | (x & part2))


cdef Pair two_point_crossover3(bitset x, bitset y):
    cdef int beg = randomint(100)
    cdef int end = randomint(100)
    cdef bitset part1 = ((1 << end) - 1) - ((1 << beg) - 1)
    cdef bitset part2 = ~part1

    return Pair((x & part1) | (y & part2), (y & part1) | (x & part2))



def test1():
    cdef bitset blackhole = 0
    cdef bitset a = 0L
    cdef bitset bound = 2 ** 30
    cdef bitset x, y

    while a < bound:
        x, y = two_point_crossover1(a, a)
        blackhole += x + y
        a += 1001

    return blackhole


def test2():
    cdef bitset blackhole = 0
    cdef bitset a = 0L
    cdef bitset bound = 2 ** 30

    while a < bound:
        offspring = two_point_crossover2(a, a)
        blackhole += offspring.x + offspring.y
        a += 1001

    return blackhole


def test3():
    cdef bitset blackhole = 0
    cdef bitset a = 0L
    cdef bitset bound = 2 ** 30

    while a < bound:
        offspring = two_point_crossover3(a, a)
        blackhole += offspring.x + offspring.y
        a += 1001

    return blackhole


#compare([test1, test2, test3])


#
# UNIFORM CROSSOVER
#

cdef Pair uni_crossover1(bitset x, bitset y):
    k = 1
    cdef bitset result1 = 0
    cdef bitset result2 = 0
    cdef int r

    for i in range(100):
        k <<= 1
        r = randomint(2)
        if r != 0:
            result1 |= x & k
            result2 |= y & k
        else:
            result1 |= y & k
            result2 |= x & k

    return Pair(result1, result2)


cdef Pair uni_crossover2(bitset x, bitset y):
    k = 1
    cdef bitset result1 = 0
    cdef bitset result2 = 0
    cdef int r

    for i in range(100):
        k <<= 1
        r = randomint(2)
        if r != 0:
            result1 |= x & k
            result2 |= y & k
        else:
            result1 |= y & k
            result2 |= x & k

    return Pair(result1, result2)


def test4():
    cdef bitset blackhole = 0
    cdef bitset a = 0L
    cdef bitset bound = 2 ** 30

    while a < bound:
        offspring = uni_crossover1(a, a)
        blackhole += offspring.x + offspring.y
        a += 50001

    return blackhole


def test5():
    cdef bitset blackhole = 0
    cdef bitset a = 0L
    cdef bitset bound = 2 ** 30

    while a < bound:
        offspring = uni_crossover2(a, a)
        blackhole += offspring.x + offspring.y
        a += 50001

    return blackhole


compare([test4, test5])
