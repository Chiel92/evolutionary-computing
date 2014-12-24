
cdef extern from "uint128.h":
    ctypedef unsigned long long uint128

cdef int size(uint128)
cdef int index(uint128)
cpdef tostring(uint128)
