from bitset cimport uint128, tostring, index, size, invert, bit
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap
from operators import two_point_crossover, uniform_crossover, randbitstream, mutate

from evolution import evolve, find_popsize
from experiments import experiment1, experiment2, experiment3
from profiling import profile
import matplotlib.pyplot as plt
import pickle


def run():
    # x contains a number consisting of more than 64 1's
    #cdef uint128 x = bit(100) - 1 - bit(95) - bit(63) - bit(31)
    #cdef uint128 y = bit(100) - 1

    #print(x)
    #print(tostring(x))
    #print(count_ones(x))
    #print(count_ones(y))
    #print(tostring(shuffle(x)))

    generate_data()
    plot_success_popsize()

def generate_data():
    data = experiment1()
    print('data: {}'.format(data))
    pickle.dump(data, open('data/exp-1', 'wb'))

def plot_success_popsize():
    data = pickle.load(open('data/exp-1', 'rb'))
    plt.plot([d[0] for d in data], [d[1] for d in data], 'ro')
    plt.axis([0, 2000, 0, 100])
    plt.xlabel('Population size')
    plt.ylabel('Successes')
    plt.grid(True)
    plt.title('Performance of various population sizes')
    plt.show()

