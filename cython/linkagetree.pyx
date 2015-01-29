from scipy.cluster.hierarchy import linkage, distance
from random import choice
from utils cimport randomint, randuint100
from utils import shuffle
from bitset cimport bit, invert, tostring

size = 100

def print_matrix(matrix):
    print('\n'.join(' '.join('{0:7}'.format(round(elem, 5)) for elem in row) for row in matrix))


def ltga(popsize, fitness):
    cdef list population = [randuint100() & (bit(size + 1) - 1) for _ in range(popsize)]

    #for x in population:
        #print(fitness(x))

    while 1:
        fos = build_fos(population)
        shuffle(population)
        #print(population)

        next_generation = []
        for i in range(0, popsize):
            if i == popsize - 1:
                parent1, parent2 = population[0], population[i]
            else:
                parent1, parent2 = population[i:i+2]

            fp1 = fitness(parent1)
            fp2 = fitness(parent2)
            for subset in fos:
                inv_subset = invert(subset, 100)
                child1 = (parent1 & subset) | (parent2 & inv_subset)
                child2 = (parent2 & subset) | (parent1 & inv_subset)
                fc1 = fitness(child1)
                fc2 = fitness(child2)
                if ((fc1 > fp1 and fc1 > fp2)
                        or (fc2 > fp1 and fc2 > fp2)):
                    parent1, parent2 = child1, child2
                    #print(fp1, fp2, fc1, fc2)
                    fp1, fp2 = fc1, fc2
            if fp1 > fp2:
                next_generation.append(parent1)
            else:
                next_generation.append(parent2)
        assert len(next_generation) == popsize
        if next_generation == population:
            break
        population = next_generation

    #for x in population:
        #print(fitness(x))
    return max(population, key=fitness)


def build_fos(population):
    observations = []
    for solution in population:
        observation = [1 if solution & bit(i) else 0 for i in range(size)]
        #observation = [1 if True else 0 for i in range(size)]
        observations.append(observation)

    dmatrix = jaccard_matrix(observations)
    lmatrix = linkage(dmatrix, method='average') # average = UPGMA

    #print(observations)
    #print(dmatrix)
    #print(lmatrix)

    fos = [bit(i) for i in range(size)]
    for i in range(len(lmatrix)):
        newcluster = fos[int(lmatrix[i][0])] | fos[int(lmatrix[i][1])]
        fos.append(newcluster)

    return list(reversed(fos))


def jaccard_matrix(observations):
    observations = list(zip(*observations)) # Flip matrix
    return distance.pdist(observations, 'jaccard')

