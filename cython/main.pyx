from bitset cimport uint128, tostring, index, size, invert, bit
from fitnessfunctions import count_ones, lin_scaled_count_ones, td_trap, tn_trap, rd_trap, rn_trap
from operators import two_point_crossover, uniform_crossover, randbitstream, mutate

from profiling import profile
import matplotlib.pyplot as plt
import pickle

import experiments2 as exp

def run():
    #generate_data()
    #plot_success_popsize()
    exp.profile_exp()


def generate_data():
    pickle.dump(exp.plot_experiment(), open('output/exp-2', 'wb'))


def plot_success_popsize():
    data = pickle.load(open('output/exp-2', 'rb'))

    plt.subplot(121)
    styles = ['ro', 'g^', 'bs', 'cD', 'mh', 'k+']
    for i, (label, points) in enumerate(data):
        plt.plot([p[0] for p in points], [p[1] for p in points], styles[i], label=label)


    #plt.axis([-10, 1340, -.2, 61])
    plt.axis([-10, 110, -.2, 61])
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0., numpoints=1)
    plt.title('Performance of population sizes with various fitness functions')
    plt.xlabel('Population size')
    plt.ylabel('Successes')
    plt.grid(True)
    plt.show()

