from setuptools import setup, Extension
from Cython.Build import cythonize
import os
import sysconfig

file_dir = os.path.dirname(os.path.abspath(__file__))

site_packages_path = sysconfig.get_path("purelib")

libraries = ["User32", "Kernel32"]

include_dirs = [
    site_packages_path,  # Include the virtual_memory_toolkit directory
]

# Define the extension module
extensions = [
    Extension(
        name="seed_changer",
        sources=["seed_changer.pyx"],
        include_dirs=include_dirs,
        language="c++",
        libraries=libraries
    )
]


os.chdir(file_dir)
# Setup script to build the extension
setup(
    ext_modules=cythonize(extensions),
)
