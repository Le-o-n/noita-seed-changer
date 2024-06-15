from setuptools import setup, Extension
from Cython.Build import cythonize
import os
import sysconfig

# Find the path to the site-packages directory
site_packages_path = sysconfig.get_path("purelib")

libraries = ["User32", "Kernel32"]

include_dirs = [
    site_packages_path,
    os.path.join(site_packages_path, 'virtual_memory_toolkit'),
]
# Define the extension module
extensions = [
    Extension(
        name="seed_hook",
        sources=["seed_hook.pyx"],
        include_dirs=include_dirs,
        language="c++",
        libraries=libraries
    )
]

# Setup script to build the extension
setup(
    ext_modules=cythonize(extensions),
)
