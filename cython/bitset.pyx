cdef extern from "uint128.h":
    ctypedef unsigned long long uint128

cdef extern int __builtin_popcountll(unsigned long long x)
cdef extern int __builtin_ctzll(unsigned long long x)


cdef int index(uint128 x):
    """
    Return position of first element in given bitset, counting from 0.
    Return 128 if bitset is empty.
    """
    cdef int part1 = __builtin_ctzll(<unsigned long long>x)
    cdef int part2 = __builtin_ctzll(<unsigned long long>(x >> 64))
    return part1 if part1 < 64 else 64 + part2


cdef int size(uint128 x):
    """Return size of given uint128."""
    return __builtin_popcountll(x) + __builtin_popcountll(<unsigned long long>(x >> 64))


cdef uint128 subtract(uint128 self, uint128 other):
    return self - (self & other)


cdef contains(uint128 self, uint128 other):
    return self & other == self


cdef uint128 invert(uint128 x, uint128 l):
    """Return inverse where universe has length l"""
    return 2ULL ** l - 1 - x


cpdef uint128 join(args):
    cdef uint128 v, result = 0
    for v in args:
        result |= v
    return result


def iterate(uint128 n):
    cdef uint128 b
    while n:
        b = n & (~n + 1)
        yield b
        n ^= b


cpdef tostring(uint128 n):
    #cdef char* bitstring = <char*>malloc(8 * sizeof(uint128) * sizeof(char) + 1)
    bitstring = []
    cdef int i = 0
    while i < 128:
        if i == 64:
            bitstring.append('|')

        if (n & <uint128>1):
            #bitstring[i] = '1'
            bitstring.append('1')
        else:
            #bitstring[i] = '0'
            bitstring.append('0')

        n >>= <uint128>1
        i += 1
    return ''.join(reversed(bitstring))

