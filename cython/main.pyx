from bitset cimport uint128, tostring, index, size


# x contains a number consisting of more than 64 1's
#cdef uint128 x = (<uint128>1 << 70) - 1
cdef uint128 x = (<uint128>1 << 127) + (<uint128>1 << 0)
#cdef uint128 x = (<uint128>0)
print(tostring(x))
print(size(x))

