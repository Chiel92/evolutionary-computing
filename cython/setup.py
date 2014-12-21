from distutils.core import setup
from Cython.Build import cythonize

setup(
    name="My hello app",
    ext_modules=cythonize('bitset.pyx', 'main.pyx'),  # accepts a glob pattern
)
#from distutils.core import setup
#from Cython.Build import cythonize
#from distutils.extension import Extension

#sourcefiles = ['bitset.pyx', 'main.pyx']

#extensions = [Extension("example", sourcefiles)]

#setup(
    #ext_modules=cythonize(extensions)
#)
