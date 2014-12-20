# encoding: utf-8
# filename: profile.py
"""
Profiling utilities.
"""

# Import profile tools
import pstats, cProfile


def profile(evalstring, glob, loc, filename='Profile.prof'):
    """Evaluate and profile given string."""
    cProfile.runctx('print({})'.format(evalstring), glob, loc, filename)
    report = pstats.Stats(filename)
    report.strip_dirs().sort_stats('time').print_stats()

def compare(functions, filename='Profile.prof'):
    """Profile a sequence of functions."""
    for f in functions:
        profile('f()', globals(), locals(), filename)

