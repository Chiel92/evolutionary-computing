cdef extern from "uint128.h":
    ctypedef unsigned long long uint128


cdef uint128 bit(int position):
    return (<uint128>1 << position)


cdef extern int __builtin_popcountll(unsigned long long x)
cdef extern int __builtin_popcount(unsigned int x)
cdef extern int __builtin_ctzll(unsigned long long x)


cdef int index(uint128 x):
    """
    Return position of first element in given bitset, counting from 0.
    Return 128 if bitset is empty.
    """
    cdef int part1 = __builtin_ctzll(<unsigned long long>x)
    cdef int part2 = __builtin_ctzll(<unsigned long long>(x >> 64))
    return part1 if part1 < 64 else 64 + part2

cdef int size_int(int x):
    """Return size of given int."""
    return __builtin_popcount(x)

cdef int size(uint128 x):
    """Return size of given uint128."""
    return __builtin_popcountll(x) + __builtin_popcountll(<unsigned long long>(x >> 64))


cdef uint128 universe = ((<uint128>1 << 127) - 1) + (<uint128>1 << 127)


cdef uint128 subtract(uint128 self, uint128 other):
    return self - (self & other)


cdef contains(uint128 self, uint128 other):
    return self & other == self


cdef uint128 invert(uint128 x, unsigned int l):
    """Return inverse where universe has length l"""
    l = 128 - l
    return subtract(((universe << l) >> l), x)


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
    bitstring = []
    cdef int i = 0
    while i < 128:
        #if i == 32 or i == 64 or i == 96:
            #bitstring.append('|')

        if (n & 1):
            bitstring.append('1')
        else:
            bitstring.append('0')

        n >>= 1
        i += 1
    return ''.join(reversed(bitstring[:]))

