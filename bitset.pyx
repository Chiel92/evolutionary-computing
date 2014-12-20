"""
Utility functions for using unsigned long longs as bitsets.
"""

ctypedef unsigned long long ull
cdef extern int __builtin_ctzll(ull x)
cdef extern int __builtin_clzll(ull x)
cdef extern int __builtin_popcountll(ull x)


cdef int index(ull x):
    """Return position of first vertex in given bitset."""
    return __builtin_ctzll(x)


cdef int domain(ull x):
    """Return position of last vertex in given bitset."""
    return 64 - __builtin_clzll(x)


cdef int size(ull x):
    """Return size of given bitset."""
    return __builtin_popcountll(x)


cdef ull subtract(ull self, ull other):
    return self - (self & other)


cdef ull invert(ull x, ull l):
    """Return inverse where universe has length l"""
    return 2ULL ** l - 1 - x


cpdef ull join(args):
    cdef ull v, result = 0
    for v in args:
        result |= v
    return result


def iterate(ull n):
    cdef ull b
    while n:
        b = n & (~n + 1)
        yield b
        n ^= b


def contains(ull self, ull other):
    return self & other == self


def tostring(self):
    return 'BitSet{{{}}}'.format(', '.join(str(index(v)) for v in iterate(self)))


def subsets(ull self, int minsize=0, int maxsize=-1):
    """Yield subbitsets from specified size ordered by size ascending."""
    if minsize < 0:
        minsize = size(self) + 1 + minsize
    if maxsize < 0:
        maxsize = size(self) + 1 + maxsize

    sets = [0ULL]
    for v in iterate(self):
        sets.extend([s | v for s in sets])

    return [s for s in sets if size(s) >= minsize and size(s) <= maxsize]

