# PicoECS
A simple ECS Framework for Pico8, made for the GD@IU May 2019 Weekend Jam

## Building
- Run the `p8gen.py` script to generate a `.p8` project from the source files (tested with Python 3.6.6)

## Project
- The `.pp8` project file used is the same as a normal Pico8 project, with the addition of `#include` statements to load in separate script files, as well as graphics and maps from existing `.p8` projects
- More of these lines can be added to include more script directories, etc.

## Editing
- Edit the `gfx.p8` project to change graphics, maps, etc.
- Create and edit scripts in the scripts folder to change code
- Rebuild and run to test the game (can be done in a batch script with `"path-to-pico8.exe" -run template.p8"`)

## To Do
- Add audio / music support to the build scipt
- Add generic batch/bash scripts for building
