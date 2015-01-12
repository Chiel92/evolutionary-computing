"""
This module contains all kinds of operators.
"""

from bitset cimport uint128, tostring, invert
from utils cimport randomint, randuint128
from utils import randbitstream
from bitset cimport bit


cpdef tuple two_point_crossover(uint128 x, uint128 y):
    cdef int k1 = 0, k2 = 0
    while k1 == k2:
        k1 = randomint(100)
        k2 = randomint(100)
    k1, k2 = max(k1, k2), min(k1, k2) # Now we have k1 > k2

    cdef uint128 m = (bit(k1) - 1) #011 (k1 ones)
    cdef uint128 part1 = invert(m, 100) #100 (k1 zeros)
    cdef uint128 part3 = (bit(k2) - 1) #001 (k2 ones)
    cdef uint128 part2 = m - part3 #010

    return (x & part1) | (y & part2) | (x & part3), (y & part1) | (x & part2) | (y & part3)


cpdef tuple uniform_crossover(uint128 x, uint128 y):
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


def mutate(uint128 x):
    # Decide number of bits to be flipped
    cdef uint128 number = 1, bit

    # The probability of this failing is extremely small
    cdef uint128 sample = randuint128()
    while sample & 1:
        sample >>= 1
        number += 1

    # Flip random bits
    # NOTE: in theory it is possible that a bit is flipped multiple times
    # But for reasons of speed and since it doesn't matter that much, we allow this to happen
    for _ in range(number):
        bit = (<uint128>1 << randomint(100))
        x ^= bit

    return x

