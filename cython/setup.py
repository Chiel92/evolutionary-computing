from distutils.core import setup
from Cython.Build import cythonize

setup(
    name="My app that uses 128 bit ints",
    ext_modules=cythonize('main.pyx', compiler_directives={'profile': True})
)

