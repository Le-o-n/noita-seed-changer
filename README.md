# Noita Seed Changer
This tool allows you to change your seed during the game while still enabling progression, such as unlocking new spells and achievements. Download the latest release from the [releases](https://github.com/Le-o-n/noita-seed-changer/releases) page.

# Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [How this works](#how-this-works)
- [License](#license)
- [Credits](#credits)

# Introduction
This tool allows you to change your seed during the game while still enabling progression, such as unlocking new spells and achievements.

### Why is this Tool Unique?
Unlike the [Noita Seed Changer](https://steamcommunity.com/sharedfiles/filedetails/?id=2284931352) workshop mod, which prevents progression in the game, this tool allows progression and doesn't get detected by the game as a mod. Other alternatives, such as [RNG42/NoitaSeedChanger](https://github.com/RNG42/NoitaSeedChanger) and [Start with custom seed by Luffy](https://modworkshop.net/mod/25898) require some setup to use and need to be loaded before the game starts. This tool uniquely can be run after the game has already started and does not require additional files to run, this tool will edit the game's running code instead of making the game load additional code on start-up, making it much more compatible for future updates. 

### Features

- **Read and Write Seed**: Read the current world seed and force a seed value for all new worlds.
- **Real-Time Code Modification**: The tool modifies the game code while it's running, eliminating the need for any mod installation.
- **Future Proof**: The game code that is targeted is located within the running game's memory by using array of byte (AOB) scans, this means that as long as future updates don't modify these handful of opcodes this program will continue to work, making this as future-proof as possible.
- **Progression-Friendly**: Continue unlocking new spells and achievements even after changing your seed.

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
This program scans the virtual memory of Noita for a specific set of opcodes (assembly instructions). These opcodes, in this particular sequence, are found only in a single targeted function. This function is responsible for writing to the seed address when you start a new world. With the seed generation algorithm implemented in Noita, the pseudo-code resembles the following, although the actual code is written in x86/x64 assembly and is much more complex:
```python3
def generate_seed(...):
  global seed
  seed = 0
  ...
  if seed == 0:
    seed = random_seed()
  ...
```
And this program will inject some code to change this pseudo-code to look like the following, note that since the user defined seed will be non-zero, the seed never gets overwritten with a new random seed and instead will be kept as the user defined seed:
```python3
def generate_seed(...):
  global seed
  seed = USER_DEFINED_SEED
  ...
  if seed == 0:
    seed = random_seed()
  ...
```

# License
GPL v3 license, more information can be found [here](https://github.com/Le-o-n/noita-seed-changer/blob/main/LICENSE).

# Credits
All written, tested and deployed by me, [Leon Bass](https://github.com/Le-o-n).
