@echo off
setlocal enabledelayedexpansion

set PYTHON_EXECUTABLE=python
set SETUP="setup.py"

cd /D "%~dp0"

%PYTHON_EXECUTABLE% %SETUP% build_ext --inplace