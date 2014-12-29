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

    #generate_data()
    plot_success_popsize()

def generate_data():
    pickle.dump(experiment1(), open('output/exp-1', 'wb'))

def plot_success_popsize():
    data = pickle.load(open('output/exp-1', 'rb'))

    plt.subplot(121)
    styles = ['ro', 'g^', 'bs', 'cD', 'mh', 'k8']
    for i, (label, points) in enumerate(data):
        plt.plot([p[0] for p in points], [p[1] for p in points], styles[i], label=label)


    plt.axis([0, 1300, 0, 35])
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0., numpoints=1)
    plt.title('Performance of population sizes with various fitness functions')
    plt.xlabel('Population size')
    plt.ylabel('Successes')
    plt.grid(True)
    plt.show()

