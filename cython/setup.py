from distutils.core import setup
from Cython.Build import cythonize

setup(
    name="My app that used 128 bit ints",
    ext_modules=cythonize('main.pyx')
)
#from distutils.core import setup
#from Cython.Build import cythonize
#from distutils.extension import Extension

#sourcefiles = ['bitset.pyx', 'main.pyx']

#extensions = [Extension("example", sourcefiles)]

#setup(
    #ext_modules=cythonize(extensions)
#)
