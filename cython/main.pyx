from bitset cimport int128, tostring

#cdef extern from "cint128.h":
    #ctypedef unsigned long long int128

# x contains a number consisting of more than 64 1's
cdef int128 x = (<int128>1 << 70) - 1
print(tostring(x))

# Casting doesn't work properly
print(tostring(<int>x))

# Shifting first seems to work however
x >>= 64
print(tostring(<int>x))

