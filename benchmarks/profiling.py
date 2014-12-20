#!/usr/bin/env python3
# encoding: utf-8
# filename: profile.py
"""
Profiling utilities.
"""

# Import profile tools
import pstats, cProfile


def profile(evalstring, glob, loc, filename='Profile.prof'):
    """Evaluate and profile given string."""
    #cProfile.runctx(evalstring, globals(), locals(), filename)
    cProfile.runctx('print({})'.format(evalstring), glob, loc, filename)
    report = pstats.Stats(filename)
    report.strip_dirs().sort_stats("time").print_stats()

def compare(function_list, filename='Profile.prof'):
    for f in function_list:
        profile('f()', globals(), locals(), filename)
