"""
This module contains all kinds of operators.
"""

from bitset cimport uint128, tostring, invert
from libc.stdlib cimport rand, srand
from libc.time cimport time


# Seed the random number generator
srand(time(NULL));


cdef extern from "stdlib.h":
    int RAND_MAX


cdef int randomint(int upperbound):
    return <int> ((rand() / <float>RAND_MAX) * upperbound)


cdef uint128 randuint128():
    cdef uint128 result = rand()
    for _ in range(3):
        result <<= 32
        result |= rand()
    return result


def randbitstream():
    cdef unsigned int sample
    cdef unsigned int i
    while 1:
        sample = rand()
        i = 1
        while i:
            yield bool(sample & i)
            i <<= 1


def two_point_crossover(uint128 x, uint128 y):
    cdef int k1 = randomint(100)
    cdef int k2 = randomint(100)
    k1, k2 = max(k1, k2), min(k1, k2)
    #print(k1, k2)

    cdef uint128 m = ((<uint128>1 << k1) - 1) #011
    cdef uint128 part1 = invert(m, 100) #100
    cdef uint128 part3 = ((<uint128>1 << k2) - 1) #001
    cdef uint128 part2 = m - part3 #010
    #print(tostring(m))
    #print(tostring(part1))
    #print(tostring(part2))
    #print(tostring(part3))

    return (x & part1) | (y & part2) | (x & part3), (y & part1) | (x & part2) | (y & part3)


def uniform_crossover(uint128 x, uint128 y):
    cdef uint128 k = randuint128()
    cdef uint128 fx = 0
    cdef uint128 fy = 0

    cdef uint128 i = 1
    while i:
        if i & k:
            fx |= x & i
            fy |= y & i
        else:
            fx |= y & i
            fy |= x & i
        i <<= 1

    return fx, fy

def mutation(uint128 x):
    # Decide number of bits to be flipped
    cdef uint128 number = 1
    randomstream = randbitstream()
    while next(randomstream):
        number <<= 1

    # Flip random bits
    # NOTE: in theory it is possible that a bit is flipped multiple times
    # But for reasons of speed and since it doesn't matter that much, we allow this to happen
    for _ in range(number):
        bit = (<uint128>1 << randomint(100))
        x ^= bit

    return x

