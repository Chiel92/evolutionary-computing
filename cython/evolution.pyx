from bitset cimport uint128
from utils cimport randomint, randuint128
from fitnessfunctions import count_zeros
from operators import two_point_crossover, uniform_crossover
from heapq import nlargest

def shuffle(list l):
    """Shuffle list using fisher-yates shuffle."""
    cdef int j

    for i in range(len(l) - 1, -1 ,-1):
        j = randomint(i + 1)
        l[i], l[j] = l[j], l[i]

fitness = count_zeros
crossover = two_point_crossover
cdef int populationsize = 50
cdef int generations = 50

def evolve():
    cdef list population = [randuint128() & ((<uint128>1 << 100) - 1) for _ in range(populationsize)]
    cdef uint128 x, y
    cdef list parents

    for _ in range(generations):
        assert len(population) == populationsize

        # Parent selection
        parents = []
        for __ in range(2):
            shuffle(population)
            for i in range(0, populationsize, 2):
                x, y = population[i], population[i + 1]

                if fitness(x) >= fitness(y):
                    parents.append(x)
                else:
                    parents.append(y)

        assert len(parents) == populationsize

        # Offspring generation
        for i in range(0, populationsize, 2):
            x, y = parents[i], parents[i + 1]
            population.extend(crossover(x, y))

        # Survival of the fittest
        population = nlargest(populationsize, population, key=fitness)
        print(nlargest(1, population, key=fitness))

