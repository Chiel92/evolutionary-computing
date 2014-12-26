from bitset cimport uint128
from utils cimport randomint, randuint128
from fitnessfunctions import count_zeros
from operators import uniform_crossover
from heapq import nlargest

def shuffle(list l):
    """Shuffle list using fisher-yates shuffle."""
    cdef int j

    for i in range(len(l) - 1, -1 ,-1):
        j = randomint(i + 1)
        l[i], l[j] = l[j], l[i]

def evolve():
    cdef int populationsize = 100
    cdef list population = [randuint128() & (<uint128>1 << 100 - 1) for _ in range(100)]
    cdef uint128 x, y
    cdef list parents

    for _ in range(10):
        # Parent selection
        parents = []
        for _ in range(2):
            shuffle(population)
            for i in range(0, populationsize, 2):
                x, y = population[i], population[i + 1]

                if count_zeros(x) >= count_zeros(y):
                    parents.append(x)
                else:
                    parents.append(y)

        assert len(population) == populationsize
        assert len(parents) == populationsize

        # Offspring generation
        for i in range(0, populationsize, 2):
            x, y = parents[i], parents[i + 1]
            population.extend(uniform_crossover(x, y))

        # Survival of the fittest
        population = nlargest(populationsize, population)

    print(population)

