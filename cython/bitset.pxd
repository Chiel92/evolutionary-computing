cdef extern from "cbitset.h":
    ctypedef unsigned long long bitset

cdef char* bitset_tostring(bitset n)
cdef void print_bitset(bitset n)
