"""
This module contains all kinds of operators.
"""

from libc.stdlib cimport rand


cdef extern from "stdlib.h":
    int RAND_MAX


ctypedef unsigned long long ull


cdef struct Pair:
    ull x
    ull y


cdef int randomint(int upperbound):
    return <int> ((rand() / <float>RAND_MAX) * upperbound)


cdef Pair two_point_crossover(ull x, ull y):
    cdef int k = randomint(100)
    cdef ull part1 = (1 << k) - 1
    cdef ull part2 = ~part1

    return Pair((x & part1) | (y & part2), (y & part1) | (x & part2))

