# Noita Seed Changer

This tool is designed to allow modifications to the seed during the runtime of the game without going through the modding framework. This enables progression such as unlocking new spells whilst modifying the seed.

# Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Examples](#examples)
- [License](#license)
- [Credits](#credits)

# Features
The key features of this tool are:
- Setting a seed.
- Viewing the current seed.
- Saving a seed for later.
- Loading a saved seed.


# Requirements
This tool only runs on Windows and has only been tested on an x64 architecture. The dependancy on windows comes from my library `virtual-memory-toolkit` relying completely on the Windows API to communicate with the process, there currently is no plan to include linux or macOS support.

To build this project, Python 3.10.10 and above is required, all other dependancies will be installed when running `./shell/build.bat` or alternatively you can `python -m pip install -r ./requirements.txt`


# Installation
There are two main ways of building this tool, downloading the precompiled executable from the releases tab or using python>3.10.10, clone the repository, and build the solution. 
## From Releases
Download the prebuilt tool from the 'Releases' page found [here](https://github.com/Le-o-n/noita-seed-changer/releases)

## Build from Repository
Note that python version 3.10.10 was used throughout so I would advice using at least this version when building yourself. The following command line code will clone the repo, install requirements and build - the final compiled executable should appear inside of a `./build` folder.  

```
git clone https://github.com/Le-o-n/noita-seed-changer.git ./noita_tool_repo
cd ./noita_tool_repo
call ./shell/build.bat
```
Then to run you can find the executable at:
```
./build/NoitaSeedTool.exe
```

## Run without compiling to an executable
If you want to run this project without having to compile to an executable, this is possible but the cython code will still require compilation.

```
call ./shell/build_seed_changer.bat
python ./src/main.py
```
