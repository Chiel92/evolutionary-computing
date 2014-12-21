from bitset cimport print_bitset

cdef extern from "cbitset.h":
    ctypedef unsigned long long bitset

# x contains a number consisting of more than 64 1's
cdef bitset x = (<bitset>1 << 70) - 1
print_bitset(x)

# Casting doesn't work properly
print_bitset(<int>x)

# Shifting first seems to work however
x >>= 64
print_bitset(<int>x)

