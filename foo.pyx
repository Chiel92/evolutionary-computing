cdef extern from "header_int128.h":
    # this is WRONG, as this would be a int64. it is here
    # just to let cython pass the first step, which is generating
    # the .c file.
    ctypedef unsigned long long uint128

#cdef extern from "stdint.h":
    #ctypedef int128_t bits
    #ctypedef unsigned long long uint128_t
    #ctypedef unsigned long long bts

#cdef extern:
    #ctypedef __int128
    #ctypedef __int128_t

#cdef int128 bar():
    #cdef int128 my_very_long_int = 1 << 64
    #return my_very_long_int

from libc.stdio cimport printf
from bitset cimport domain

print(sizeof(uint128))
cdef uint128 bar1 = 1 << 63
cdef uint128 bar2 = 1 << 75
print(int(bar1), int(bar2))
printf("%d\n", domain(bar1))
printf("%d\n", domain(bar2))

