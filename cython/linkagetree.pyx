from scipy.cluster.hierarchy import linkage, distance
from random import choice
from utils cimport randomint, randuint100
from bitset cimport bit, invert
import numpy
from math import log

#print(distance.pdist.__doc__)
#print(linkage.__doc__)

size = 5

def print_matrix(matrix):
    print('\n'.join(' '.join(str(round(elem, 5)) for elem in row) for row in matrix))


def gomea(int popsize, fitness):
    cdef list population = [randuint100() for _ in range(20)]

    dmatrix = distance_matrix(population)
    print(dmatrix)
    #print(flip_matrix(dmatrix))
    return

    while 1:
        fos = learn_linkagetree(population)
        for solution in population:
            for subset in fos:
                donor = choice(population)
                solution = greedy_recombination(solution, donor, subset, fitness)
    return solution


def learn_linkagetree(population):
    dmatrix = distance_matrix(population)
    return linkage(dmatrix, method='average')


def distance_matrix(population):
    observations = []
    for solution in population:
        observation = [1 if solution & bit(i) else 0 for i in range(size)]
        observations.append(observation)
    #return observations
    #observations = flip_matrix(observations)
    #observations = numpy.matrix(observations)
    print_matrix(observations)
    observations = list(zip(*observations))
    print_matrix(distance_matrix2(population))

    return distance.pdist(observations, 'correlation')

def foo(p1, p2, p12):
    if p1 == 0 or p2 == 0:
        result = 0
    elif p12 == 0:
        result = 0
    else:
        result = p12 * log(p12 / (p1 * p2), 2)
    return result

def distance_matrix2(population):
    """Test implementation"""
    observations = []
    for solution in population:
        observation = [1 if solution & bit(i) else 0 for i in range(size)]
        observations.append(observation)

    m = len(observations)
    result = [[None for _ in range(size)] for _ in range(size)]
    for i in range(size):
        for j in range(size):
            #p12_11 = sum(1 for x in observations if x[i] == 1 and x[j] == 1) / m
            #p12_01 = sum(1 for x in observations if x[i] == 0 and x[j] == 1) / m
            #p12_10 = sum(1 for x in observations if x[i] == 1 and x[j] == 0) / m
            #p12_00 = sum(1 for x in observations if x[i] == 0 and x[j] == 0) / m
            #p1 = sum(1 for x in observations if x[i] == 1) / m
            #p2 = sum(1 for x in observations if x[j] == 1) / m
            #assert 0 <= p1 <= 1
            #assert 0 <= p2 <= 1
            #assert 0 <= p12_00 <= 1
            #assert 0 <= p12_10 <= 1
            #assert 0 <= p12_01 <= 1
            #assert 0 <= p12_11 <= 1
            #assert p12_10 + p12_11 == p1
            #assert p12_01 + p12_11 == p2

            #result[i][j] = (foo(p1, p2, p12_11) # 1 1
                    #+ foo(1 - p1, p2, p12_01) # 0 1
                    #+ foo(p1, 1 - p2, p12_10) # 1 0
                    #+ foo(1 - p1, 1 - p2, p12_00) # 0 0
                #)
            def p(x, y):
                return sum(1 for x in observations if x[i] == x and x[j] == y) / m

            result[i][j] = sum(
                    foo(p(x, 0) + p(x, 1), p(0, y) + p(1, y), p(x, y))
                    for x in (0, 1) for y in (0, 1)
                )
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
