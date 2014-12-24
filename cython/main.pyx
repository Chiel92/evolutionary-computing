from bitset cimport uint128, tostring, index, size, invert


# x contains a number consisting of more than 64 1's
cdef uint128 x = (<uint128>1 << 100)

print(tostring(x))
print(tostring(invert(x, 32)))

