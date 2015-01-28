from math import log

size = 100

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

