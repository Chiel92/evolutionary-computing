from distutils.core import setup
from Cython.Build import cythonize

setup(
    name = "My hello app",
    ext_modules = cythonize('foo2.pyx'),  # accepts a glob pattern
)
#from distutils.core import setup
#from Cython.Build import cythonize
#from distutils.extension import Extension

#sourcefiles = ['foo2.pyx', 'bitset.c']

#extensions = [Extension("example", sourcefiles)]

#setup(
    #ext_modules = cythonize(extensions)
#)
