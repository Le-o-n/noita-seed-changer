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
Unlike the [Noita Seed Changer](https://steamcommunity.com/sharedfiles/filedetails/?id=2284931352) workshop mod, which prevents progression in the game, this tool allows progression and doesn't get detected by the game as a mod. Other alternatives, such as [RNG42/NoitaSeedChanger](https://github.com/RNG42/NoitaSeedChanger) and [Start with custom seed by Luffy](https://modworkshop.net/mod/25898) require some setup to use and need to be loaded before the game starts. This tool uniquely can be run after the game has already started and does not require additional files, simply put this tool will edit the game's current code instead of loading new mod code making it much more compatible for future updates. 

### Features
- **Real-Time Code Modification:** This tool hooks onto the running code and modifies it as the game is running, avoiding the need to store files that the game loads before starting.
- **Minimal Changes for Future-Proofing:** It only writes 4 bytes to memory, making it as future-proof as possible.
- **Setting and Viewing Seeds:** Easily set a new seed and view the current seed within the game.

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
This program scans the virtual memory of Noita for a specific set of opcodes (assembly instructions), these series of opcodes in this order are only found in a single function that is targeted, this function is responsible for writing to the seed address when you start up a new world. With the seed generation algorithm implemented in noita, the pseudo-code looks something like the following, although the actual code is acually in x86/x64 assembly and much more complicated:
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
