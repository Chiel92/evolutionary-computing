from libc.stdlib cimport rand, srand
from libc.time cimport time
from libc.math cimport ceil

from bitset cimport bit


# Seed the random number generator
#srand(time(NULL));


cdef extern from "stdlib.h":
    int RAND_MAX


cdef int randomint(int upperbound):
    """Upperbound is exclusive."""
    return <int> ((rand() / <float>RAND_MAX) * upperbound)


cdef uint128 randuint128():
    cdef uint128 result = rand()
    for _ in range(4):
        result <<= 31
        result |= rand()
    return result


cdef uint128 randuint100():
    cdef uint128 result = rand()
    for _ in range(3):
        result <<= 31
        result |= rand()
    return result & (bit(100) - 1)


def randbitstream():
    cdef unsigned int sample
    cdef unsigned int i
    while 1:
        sample = rand()
        i = 1
        while i:
            yield bool(sample & i)
            i <<= 1

def shuffle(list l):
    """Shuffle list using fisher-yates shuffle."""
    cdef int j

    for i in range(len(l) - 1, -1 ,-1):
        j = randomint(i + 1)
        l[i], l[j] = l[j], l[i]

def shuffled(l):
    """Shuffle list using fisher-yates shuffle."""
    result = l[:]
    shuffle(result)
    return result

