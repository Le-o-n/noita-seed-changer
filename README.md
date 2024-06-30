# Noita Seed Changer

This tool is designed to allow modifications to the seed during the runtime of the game without going through the modding framework. Crucially, this program still enables progression, such as unlocking achievements and new spells.

# Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Examples](#examples)
- [How this works](#how-this-works)
- [License](#license)
- [Credits](#credits)

# Features
The key features of this tool are:
- Setting a seed.
- Viewing the current seed.


# Requirements
This tool only runs on Windows and has only been tested on an x64 architecture. The dependancy on windows comes from my library `virtual-memory-toolkit` ([github](https://github.com/Le-o-n/cython-virtual-memory-toolkit), [PyPi](https://pypi.org/project/virtual-memory-toolkit/))  relying completely on the Windows API to communicate with the process, there currently is no plan to include linux or macOS support.

To build this project, Python 3.10.10 and above is required, all other python library dependancies will be installed when running `./shell/build.bat` or alternatively you can `python -m pip install -r ./requirements.txt`. Note that you need an install of a C/C++ compiler in order to build with Cython, this can be installed using [MinGW](https://www.mingw-w64.org/)


# Installation
There are two main ways of building this tool, downloading the precompiled executable from the releases tab or using python>3.10.10, clone the repository, and build the solution. 
## From Releases
Download the prebuilt tool from the 'Releases' page found [here](https://github.com/Le-o-n/noita-seed-changer/releases)

## Build from Repository
Note that python version 3.10.10 was used throughout so I would advice using at least this version when building yourself. The following command line code will clone the repo, install requirements and build - the final compiled executable should appear inside of a `./build` folder if successful.  

```
git clone https://github.com/Le-o-n/noita-seed-changer.git ./noita_tool_repo
cd ./noita_tool_repo
call ./shell/build.bat
```
Then to run you can find the executable at:
```
./build/noita_seed_tool_x64_vX.X.X.exe
```

## Run without compiling to an executable
If you want to run this project without having to compile to an executable, this is possible but the cython code will still require compilation.

```
call ./shell/build_seed_changer.bat
python ./src/main.py
```

# How this works
This program scans the virtual memory of Noita for a specific set of opcodes (assembly instructions), these series of opcodes in this order are only found in a single function that is targeted, this function is responsible for writing to the seed address when you start up a new world. With the seed generation algorithm implemented in noita, the pseudo-code looks something like the following, although the actual code is acually in x86/x64 assembly:
```python3
def generate_seed(...):
  global seed
  seed = 0
  ...
  if seed != 0:
    return seed
  seed = random_seed()
  ...
```
And this program will inject some code to change this pseudo-code to look like the following:
```python3
def generate_seed(...):
  global seed
  seed = USER_DEFINED_SEED
  ...
  if seed != 0:
    return seed
  seed = random_seed()
  ...
```
