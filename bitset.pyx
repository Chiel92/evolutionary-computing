"""
Utility functions for using unsigned long longs as bitsets.
"""

cdef extern int __builtin_ctzll(unsigned long long x)
cdef extern int __builtin_clzll(unsigned long long x)
cdef extern int __builtin_popcountll(unsigned long long x)


cpdef int index(unsigned long long x):
    """Return position of first vertex in given bitset."""
    return __builtin_ctzll(x)


cpdef int domain(unsigned long long x):
    """Return position of last vertex in given bitset."""
    return 64 - __builtin_clzll(x)


cpdef int size(unsigned long long x):
    """Return size of given bitset."""
    return __builtin_popcountll(x)


cpdef unsigned long long subtract(unsigned long long self, unsigned long long other):
    return self - (self & other)


cpdef unsigned long long join(args):
    cdef unsigned long long v, result = 0
    for v in args:
        result |= v
    return result


cpdef unsigned long long invert(unsigned long long x, unsigned long long l):
    """Return inverse where universe has length l"""
    return 2 ** l - 1 - x


def iterate(unsigned long long n):
    cdef unsigned long long b
    while n:
        b = n & (~n + 1)
        yield b
        n ^= b

def contains(unsigned long long self, unsigned long long other):
    return self & other == self


def tostring(self):
    return 'BitSet{{{}}}'.format(', '.join(str(index(v)) for v in iterate(self)))


def subsets(unsigned long long self, int minsize=0, int maxsize=-1):
    """Yield subbitsets from specified size ordered by size ascending."""
    if minsize < 0:
        minsize = size(self) + 1 + minsize
    if maxsize < 0:
        maxsize = size(self) + 1 + maxsize

    sets = [0L]
    for v in iterate(self):
        sets.extend([s | v for s in sets])

    return [s for s in sets if size(s) >= minsize and size(s) <= maxsize]

