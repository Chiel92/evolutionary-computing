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
    cProfile.runctx(evalstring, glob, loc, filename)
    report = pstats.Stats(filename)
    report.strip_dirs().sort_stats("time").print_stats()

