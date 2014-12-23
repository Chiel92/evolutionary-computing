from libc.stdlib cimport malloc
from libc.stdio cimport printf
#from string cimport strlen
cdef extern from "string.h":
    size_t strlen(const char *s)


ctypedef long bitset
#def bitset_tostring(bitset n):
    #bitstring = []
    #cdef int i = 0
    #while n:
        #if (n & <bitset>1):
            #bitstring.append('1')
        #else:
            #bitstring.append('0')

        #n >>= <bitset>1
        #i += 1
    #return str(''.join(reversed(bitstring)))

cdef void reverse_string(char s[]):
    cdef int length = strlen(s)
    cdef int c, i, j

    #for (i = 0, j = length - 1; i < j; i++, j--)
    for i in range(length):
        j = length - i
        if j >= i:
            break
        c = s[i];
        s[i] = s[j];
        s[j] = c;

cdef char* bitset_tostring(bitset n):
    cdef char* bitstring = <char*>malloc(8 * sizeof(bitset) * sizeof(char) + 1)
    cdef int i = 0
    while n:
        if (n & <bitset>1):
            bitstring[i] = '1'
        else:
            bitstring[i] = '0'

        n >>= <bitset>1
        i += 1
    reverse_string(bitstring)
    return bitstring

cdef void print_bitset(bitset n):
    printf("%s\n", bitset_tostring(n))

cdef bitset x = 5 << 40
print_bitset(x)
#print(bitset_tostring(x))
