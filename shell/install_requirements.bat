@echo off
setlocal enabledelayedexpansion

set PYTHON_EXECUTABLE=python
set SETUP="./src/seed_changer/setup.py"

cd /D "%~dp0"
cd ..


%PYTHON_EXECUTABLE% -m pip install -r ./requirements.txt