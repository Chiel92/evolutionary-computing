cdef extern from "gcc_int128.h":
    ctypedef unsigned long long int128

cdef extern int __builtin_popcountll(unsigned long long x)
cdef extern int __builtin_ctzll(unsigned long long x)
cdef extern int __builtin_clzll(unsigned long long x)


cdef int index(int128 x):
    """Return position of first vertex in given bitset."""
    return __builtin_ctzll(x)


cdef int domain(int128 x):
    """Return position of last vertex in given bitset."""
    return 64 - __builtin_clzll(x)

cdef int128 subtract(int128 self, int128 other):
    return self - (self & other)


cdef contains(int128 self, int128 other):
    return self & other == self


cdef int size(int128 x):
    """Return size of given int128."""
    return __builtin_popcountll(x)


cdef int128 invert(int128 x, int128 l):
    """Return inverse where universe has length l"""
    return 2ULL ** l - 1 - x


cpdef int128 join(args):
    cdef int128 v, result = 0
    for v in args:
        result |= v
    return result


def iterate(int128 n):
    cdef int128 b
    while n:
        b = n & (~n + 1)
        yield b
        n ^= b


cpdef tostring(int128 n):
    #cdef char* bitstring = <char*>malloc(8 * sizeof(int128) * sizeof(char) + 1)
    bitstring = []
    cdef int i = 0
    while i < 128:
        if (n & <int128>1):
            #bitstring[i] = '1'
            bitstring.append('1')
        else:
            #bitstring[i] = '0'
            bitstring.append('0')

        n >>= <int128>1
        i += 1
    return ''.join(reversed(bitstring))

