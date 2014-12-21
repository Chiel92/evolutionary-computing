from bitset cimport print_bitset, bitset_tostring

cdef extern from "cbitset.h":
    ctypedef unsigned long long bitset

cdef bitset x = <bitset>5 << 70
print_bitset(x)
print(bitset_tostring(x))
