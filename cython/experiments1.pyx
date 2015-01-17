from bitset cimport uint128, tostring, bit
from evolution import evolve
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap, rd_trap, rn_trap
from operators import two_point_crossover, uniform_crossover
from profiling import profile


def profile_exp1():
    for fitness, popsize in [(count_ones, 310), (lin_scaled_count_ones, 730),
            (td_trap, 1210), (tn_trap, 610)]:
        print(fitness.__doc__)
        def dostuff():
            _, iterations = evolve(popsize, fitness, two_point_crossover, mutation=False, return_iterations=True)
            print('Iterations: {}'.format(iterations))
        profile(dostuff)

def profile_exp2():
    for fitness, popsize in [(count_ones, 70), (lin_scaled_count_ones, 160),
            (tn_trap, 850)]:
        print(fitness.__doc__)
        profile(lambda: evolve(popsize, fitness, uniform_crossover, mutation=False))

def profile_exp3():
    for fitness, popsize in [(count_ones, 110), (lin_scaled_count_ones, 90),
            (tn_trap, 490)]:
        def dostuff():
            _, iterations = evolve(popsize, fitness, uniform_crossover, mutation=True, return_iterations=True)
            print('Iterations: {}'.format(iterations))
        profile(dostuff)


def binarysearch_experiment1():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap, rd_trap, rn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(binarysearch_popsize(fitness, two_point_crossover))))
    return data


def binarysearch_experiment2():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(binarysearch_popsize(fitness, uniform_crossover))))
    return data


def binarysearch_experiment3():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(binarysearch_popsize(fitness, uniform_crossover, mutation=True))))
    return data


def plot_experiment1():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(plot_popsize(fitness, two_point_crossover))))
    return data


def plot_experiment2():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, tn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(plot_popsize(fitness, uniform_crossover))))
    return data


def plot_experiment3():
    data = []
    for fitness in [count_ones, lin_scaled_count_ones, tn_trap]:
        print(fitness.__doc__)
        data.append((fitness.__doc__, list(plot_popsize(fitness, uniform_crossover, mutation=True))))
    return data


def plot_popsize(fitness, crossover, mutation=False):
    tries = 60
    min_successes = 58

    for popsize in range(10, 1281, 20):
        print(popsize)
        successes = run_popsize(tries, popsize, fitness, crossover, mutation)
        yield (popsize, successes)

def binarysearch_popsize(fitness, crossover, mutation=False):
    tries = 60
    min_successes = 58

    popsize = 10

    # Find bounds for popsize
    while 1:
        successes = run_popsize(tries, popsize, fitness, crossover, mutation)
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

        successes = run_popsize(tries, popsize, fitness, crossover, mutation)
        yield (popsize, successes)
        if successes >= min_successes:
            upperbound = popsize
        else:
            lowerbound = popsize


def run_popsize(tries, popsize, fitness, crossover, mutation):
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
