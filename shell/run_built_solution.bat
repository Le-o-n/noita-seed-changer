@echo off
setlocal enabledelayedexpansion

set PYTHON_EXECUTABLE=python
set SETUP="./src/seed_changer/setup.py"

cd /D "%~dp0"
cd ..

@echo off
for %%i in ("./dist/*.exe") do (
    call "./dist/%%i"
    exit /b
)