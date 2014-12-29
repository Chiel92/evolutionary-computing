from bitset cimport uint128, tostring, bit
from utils cimport randomint, randuint100
from utils import shuffle, shuffled
from fitnessfunctions import count_ones
from operators import two_point_crossover, uniform_crossover, mutate
from heapq import nlargest


def select_parents(list population, int popsize, fitness):
    cdef list parents = []
    for i in range(0, popsize, 2):
        x, y = population[i], population[i + 1]

        if fitness(x) >= fitness(y):
            parents.append(x)
        else:
            parents.append(y)

    return parents


def generate_offspring(list parents, int popsize, crossover):
    cdef list offspring = []
    for i in range(0, popsize, 2):
        x, y = parents[i], parents[i + 1]
        offspring.extend(crossover(x, y))
    return offspring


def evolve(int popsize, fitness, crossover, mutation):
    cdef list population = [randuint100() for _ in range(popsize)]
    cdef list newpopulation, offspring
    cdef uint128 x, y
    cdef list parents

    # Population is kept sorted throughout the algorithm
    population.sort(key=fitness, reverse=True)
    #assert all(fitness(population[i]) >= fitness(population[i+1]) for i in range(len(population) - 1))

    while 1:
        assert len(population) == popsize

        # Parent selection
        parents = select_parents(population, popsize, fitness)
        parents.extend(select_parents(shuffled(population), popsize, fitness))

        #assert all(fitness(population[i]) >= fitness(population[i+1]) for i in range(len(population) - 1))
        assert len(parents) == popsize

        # Offspring generation
        offspring = generate_offspring(parents, popsize, crossover)

        # Mutation
        if mutation:
            for i in range(len(offspring)):
                offspring[i] = mutate(offspring[i])

        # Survival of the fittest
        newpopulation = population + offspring
        newpopulation.sort(key=fitness, reverse=True)
        newpopulation = newpopulation[:popsize]

        # Terminate if offspring doesn't survive
        if newpopulation == population:
            break

        population = newpopulation

    best_solution = population[0]
    #print('Best solution found: {}'.format(tostring(best_solution)))
    #print(tostring(best_solution))
    return best_solution


def find_popsize(fitness, crossover, mutation=False):
    tries = 30
    min_successes = 29

    popsize = 10

    # Find bounds for popsize
    while 1:
        successes = test_popsize(tries, popsize, fitness, crossover, mutation)
        yield (popsize, successes)
        if successes >= min_successes:
            break
        else:
            if popsize == 1280:
                print('Minimal required popsize: {}'.format(popsize))
                return
            popsize *= 2
        print('Bounds: ({}, infinity)'.format(popsize))

    upperbound = popsize
    lowerbound = int(popsize / 2)

    # Find popsize
    while 1:
        print('Bounds: ({}, {})'.format(lowerbound, upperbound))
        popsize = int(round((upperbound + lowerbound) / 2, -1))
        if popsize == lowerbound or popsize == upperbound:
            print('Minimal required popsize: {}'.format(upperbound))
            return

        successes = test_popsize(tries, popsize, fitness, crossover, mutation)
        yield (popsize, successes)
        if successes >= min_successes:
            upperbound = popsize
        else:
            lowerbound = popsize


def test_popsize(tries, popsize, fitness, crossover, mutation):
    cdef uint128 optimum = bit(100) - 1
    failures = 0
    for _ in range(tries):
        solution = evolve(popsize, fitness, crossover, mutation)
        if solution != optimum:
            failures += 1
        #if failures > 1:
            #break
    #print('failures: {}'.format(failures))
    #print('optimum:  {}'.format(tostring(optimum)))
    #print('solution: {}'.format(tostring(solution)))
    return tries - failures

