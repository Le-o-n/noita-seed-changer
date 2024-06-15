@echo off
setlocal enabledelayedexpansion

set PYTHON_EXECUTABLE=python
set SETUP="setup.py"

cd /D "%~dp0"

python setup.py build_ext --inplace