@echo off
setlocal enabledelayedexpansion

set PYTHON_EXECUTABLE=python
set SETUP="./src/seed_changer/setup.py"

cd /D "%~dp0"
cd ..

call ./shell/install_requirements.bat
call ./shell/build_seed_changer.bat

nuitka --follow-imports --output-dir=dist src/main.py --onefile --output-filename=noita_seed_tool_x64_v1.0.0.exe