from bitset cimport uint128, tostring, bit
from utils cimport randomint, randuint100
from utils import shuffle
from fitnessfunctions import count_ones
from operators import two_point_crossover, uniform_crossover
from heapq import nlargest

fitness = count_ones
crossover = two_point_crossover

def evolve(int popsize):
    cdef list population = [randuint100() for _ in range(popsize)]
    cdef list newpopulation, offspring
    cdef uint128 x, y
    cdef list parents

    while 1:
        assert len(population) == popsize

        # Parent selection
        parents = []
        for __ in range(2):
            shuffle(population)
            for i in range(0, popsize, 2):
                x, y = population[i], population[i + 1]

                if fitness(x) >= fitness(y):
                    parents.append(x)
                else:
                    parents.append(y)

        assert len(parents) == popsize

        # Offspring generation
        offspring = []
        for i in range(0, popsize, 2):
            x, y = parents[i], parents[i + 1]
            offspring.extend(crossover(x, y))

        # Survival of the fittest
        newpopulation = nlargest(popsize, population + offspring, key=fitness)

        # Terminate if offspring doesn't survive
        if newpopulation == population:
            break

        population = newpopulation

    best_solution = nlargest(1, population, key=fitness)[0]
    #print('Best solution found: {}'.format(tostring(best_solution)))
    print(tostring(best_solution))
    return best_solution


def find_popsize():
    popsize = 10

    # Find bounds for popsize
    while 1:
        print('Bounds: ({}, infinity)'.format(popsize))
        if test_popsize(popsize):
            break
        else:
            if popsize == 1280:
                return popsize
            popsize *= 2

    upperbound = popsize
    lowerbound = int(popsize / 2)

    # Find popsize
    while 1:
        print('Bounds: ({}, {})'.format(lowerbound, upperbound))
        popsize = int(round((upperbound + lowerbound) / 2, -1))
        if popsize == lowerbound or popsize == upperbound:
            return upperbound

        if test_popsize(popsize):
            upperbound = popsize
        else:
            lowerbound = popsize


def test_popsize(popsize):
    cdef uint128 optimum = bit(100) - 1
    failures = 0
    for _ in range(30):
        if evolve(popsize) != optimum:
            failures += 1
        if failures > 1:
            break
    return failures <= 1

