# distutils: sources = bitset.c

#from cbitset cimport test123
#cimport cbitset
#cdef extern from "stdio.h":
    #printf
from libc.stdio cimport printf

cdef extern from "bitset.h":
    ctypedef unsigned long long bitset
    void test123()
    void print_bitset(int n)
    #char* bitset_tostring(bitset n)

cdef void main2():
    printf("Available bits: %d\n", 8 * sizeof(bitset))
    cdef bitset x = <bitset>5 << 90
    print_bitset(x)
    #cbitset.test123()
    test123()

main2()
#print(bitset_tostring(x))
print('Hello world!')
