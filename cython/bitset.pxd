
cdef extern from "gcc_int128.h":
    ctypedef unsigned long long int128

cdef int size(int128)
cdef int domain(int128)
cdef int index(int128)
cpdef tostring(int128)
