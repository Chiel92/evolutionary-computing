from evolution import find_popsize
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap, rd_trap, rn_trap
from operators import two_point_crossover, uniform_crossover


def experiment1():
    #for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap, rd_trap, rn_trap]:
    for fitness in [count_ones]:
        print(find_popsize(fitness, two_point_crossover))


def experiment2():
    for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap]:
    #for fitness in [tn_trap]:
        print(find_popsize(fitness, uniform_crossover))


def experiment3():
    for fitness in [count_ones, lin_scaled_count_ones, td_trap, tn_trap]:
    #for fitness in [tn_trap]:
        print(find_popsize(fitness, uniform_crossover, mutation=True))

