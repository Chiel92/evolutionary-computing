from bitset cimport uint128, tostring
from libc.stdio cimport printf


# x contains a number consisting of more than 64 1's
cdef uint128 x = (<uint128>1 << 70) - 1
print(tostring(x))
print(x)

# Casting works using cython stuff
print(tostring(<unsigned int>x))
print(<unsigned int>x)
#print(2**32 - 1)

# Casting doesn't work properly using c stuff
printf("%d\n", <unsigned int>x)


