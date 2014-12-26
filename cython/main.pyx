from bitset cimport uint128, tostring, index, size, invert, bit
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap
from operators import two_point_crossover, uniform_crossover, randbitstream, mutation

from evolution import evolve, find_popsize

# x contains a number consisting of more than 64 1's
#cdef uint128 x = bit(100) - 1 - bit(95) - bit(63) - bit(31)
#cdef uint128 y = bit(100) - 1

#print(x)
#print(tostring(x))
#print(count_ones(x))
#print(count_ones(y))
#print(tostring(shuffle(x)))

print(find_popsize())
