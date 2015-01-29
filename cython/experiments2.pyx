from bitset cimport uint128, tostring, bit
from fitnessfunctions import count_ones, lin_scaled_count_ones, rd_trap, rn_trap
from profiling import profile
from linkagetree import ltga


def profile_exp():
    for fitness, popsize in [(count_ones, 10), (lin_scaled_count_ones, 20),
            (rd_trap, 50), (rn_trap, 50)]:
        print(fitness.__doc__)
        def dostuff():
            _, iterations = ltga(popsize, fitness, return_iterations=True)
            print('Iterations: {}'.format(iterations))
        profile(dostuff)


def binarysearch_experiment():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, rd_trap, rn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(binarysearch_popsize(fitness))))
    return data


def plot_experiment():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, rd_trap, rn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(plot_popsize(fitness))))
    return data



def plot_popsize(fitness):
    tries = 60
    min_successes = 58

    for popsize in range(10, 100, 10):
        print(popsize)
        successes = run_popsize(tries, popsize, fitness)
        yield (popsize, successes)


def binarysearch_popsize(fitness):
    tries = 60
    min_successes = 58

    popsize = 10

    # Find bounds for popsize
    while 1:
        successes = run_popsize(tries, popsize, fitness)
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

        successes = run_popsize(tries, popsize, fitness)
        yield (popsize, successes)
        if successes >= min_successes:
            upperbound = popsize
        else:
            lowerbound = popsize


def run_popsize(tries, popsize, fitness):
    cdef uint128 optimum = bit(100) - 1
    failures = 0
    for _ in range(tries):
        solution = ltga(popsize, fitness)
        if solution != optimum:
            failures += 1
        #if failures > 1:
            #break
    #print('failures: {}'.format(failures))
    #print('optimum:  {}'.format(tostring(optimum)))
    #print('solution: {}'.format(tostring(solution)))
    return tries - failures
