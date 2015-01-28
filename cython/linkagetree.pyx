from scipy.cluster.hierarchy import linkage, distance
from random import choice
from utils cimport randomint, randuint100
from bitset cimport bit, invert
import numpy
from math import log

#print(distance.pdist.__doc__)
#print(linkage.__doc__)

size = 6

def print_matrix(matrix):
    print('\n'.join(' '.join('{0:7}'.format(round(elem, 5)) for elem in row) for row in matrix))


def gomea(int popsize, fitness):
    cdef list population = [randuint100() for _ in range(20)]

    fos = build_fos(population)
    print(fos)
    return

    while 1:
        fos = build_fos(population)
        for solution in population:
            for subset in fos:
                donor = choice(population)
                solution = greedy_recombination(solution, donor, subset, fitness)
    return solution


def build_fos(population):
    observations = []
    for solution in population:
        #observation = [1 if solution & bit(i) else 0 for i in range(size)]
        observation = [1 if True else 0 for i in range(size)]
        observations.append(observation)

    dmatrix = jaccard_matrix(observations)
    lmatrix = linkage(dmatrix, method='average') # average = UPGMA

    #print(observations)
    #print(dmatrix)
    #print(lmatrix)

    fos = [[i] for i in range(size)]
    for i in range(len(lmatrix)):
        newcluster = fos[int(lmatrix[i][0])] + fos[int(lmatrix[i][1])]
        fos.append(newcluster)

    return fos


def jaccard_matrix(observations):
    observations = list(zip(*observations)) # Flip matrix
    return distance.pdist(observations, 'jaccard')


def mutual_information_matrix(observations):
    """Compute the mutual information between every pair of bits in the population."""
    m = len(observations)
    result = [[None for _ in range(size)] for _ in range(size)]
    for i in range(size):
        for j in range(size):
            def p(x, y):
                result = sum(1 for obs in observations if obs[i] == x and obs[j] == y) / m
                #print(result)
                return result

            result[i][j] = sum(
                    I(p(x, 0) + p(x, 1), p(0, y) + p(1, y), p(x, y))
                    for x in (0, 1) for y in (0, 1)
                )
    return result


def I(p1, p2, p12):
    if p1 == 0 or p2 == 0:
        result = 0
    elif p12 == 0:
        result = 0
    else:
        result = p12 * log(p12 / (p1 * p2), 2)
    return result


def flip_matrix(matrix):
    length = len(matrix)
    width = len(matrix[0])
    #result = [[None for _ in range(length)] for _ in range(width)]
    result = [[None] * length for _ in range(width)]
    for i in range(length):
        for j in range(width):
            result[j][i]= matrix[i][j]
    return result

def greedy_recombination(solution, donor, subset, fitness):
    inv_subset = invert(subset, 100)
    newsolution = (solution & inv_subset) | (donor & subset)
    if fitness(newsolution) > fitness(solution):
        return newsolution
    return solution
