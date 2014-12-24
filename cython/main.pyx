from bitset cimport uint128, tostring, index, size, invert
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap
from operators import two_point_crossover, uniform_crossover


# x contains a number consisting of more than 64 1's
cdef uint128 x = (<uint128>1 << 100) - 1
cdef uint128 y = (<uint128>0 << 50)

print(tostring(x))
print(tostring(y))

fx, fy = two_point_crossover(x, y)
print(tostring(fx))
print(tostring(fy))

