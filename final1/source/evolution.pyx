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


def evolve(int popsize, fitness, crossover, mutation, return_iterations=False):
    cdef list population = [randuint100() for _ in range(popsize)]

    cdef list newpopulation, offspring
    cdef uint128 x, y
    cdef list parents

    # Population is kept sorted throughout the algorithm
    population.sort(key=fitness, reverse=True)
    assert all(fitness(population[i]) >= fitness(population[i+1]) for i in range(len(population) - 1))

    iterations = 0
    while 1:
        iterations += 1
        assert len(population) == popsize

        # Parent selection
        parents = select_parents(shuffled(population), popsize, fitness)
        parents.extend(select_parents(shuffled(population), popsize, fitness))

        assert all(fitness(population[i]) >= fitness(population[i+1]) for i in range(len(population) - 1))
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

    if return_iterations:
        return best_solution, iterations
    return best_solution


