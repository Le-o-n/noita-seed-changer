from setuptools import setup, Extension
from Cython.Build import cythonize
import os
import sysconfig

root_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(root_dir, "src")

libraries = ["User32", "Kernel32"]

include_dirs = [
    src_dir
]

# Define the extension module
extensions = [
    Extension(
        name="seed_hook.seed_hook",
        sources=["src/seed_hook/seed_hook.pyx"],
        include_dirs=include_dirs,
        language="c++",
        libraries=libraries
    )
]

# Setup script to build the extension
setup(
    name="noita-seed-changer",
    version="0.1",
    packages=["seed_hook"],
    package_dir={
        "seed_hook": "./src/seed_hook"
    },
    ext_modules=cythonize(extensions),
)
