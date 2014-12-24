from libc.stdlib cimport rand, srand
from libc.time cimport time


# Seed the random number generator
srand(time(NULL));


cdef extern from "stdlib.h":
    int RAND_MAX


cdef int randomint(int upperbound):
    """Upperbound is exclusive."""
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

