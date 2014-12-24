from bitset cimport uint128, tostring, index, size, invert
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap


# x contains a number consisting of more than 64 1's
cdef uint128 x = (<uint128>1 << 100)

print(tostring(x))
print(count_ones(x))
print(lin_scaled_count_ones(x))
print(td_trap(x))
print(tn_trap(x))

