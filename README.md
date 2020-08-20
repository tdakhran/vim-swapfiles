# Introduction
`vim-swapfiles` uses user defined list of patterns to cycle between files in VIM. 
This helps in programming languages like `C++` to cycle between source and header files.

## Example
If you have `src/somefile.cpp` currently opened in VIM buffer and next variable defined in `.vimrc`
```vim
let g:swap_files_groups = [['src/{}.cpp', 'include/{}.h']]
```
calling function in VIM command line
```vim
:SwapFiles
```
will open new/existing buffer with `include/somefile.h`, if file exists.
Calling the `SwapFiles` again will open `src/somefile.cpp`.
## Configuration
Set `g:swap_files_groups` to define patterns.
`{}` is a wildcard for filename.
```vim
let g:swap_files_groups = [['src/{}.cpp', 'include/{}.h'], ['{}.cuh', '{}.cu']]
```
## Jumping Between Files
Call `:SwapFiles` to cycle between files.
# Installation
## Requirements
VIM needs to support `python3`. Check the output of the `:version` to verify.
## Install using `vim-plug`
* Add next line into `.vimrc`
```vim
Plug 'tdakhran/vim-swapfiles'
```
* Execute `vim +PlugInstall +qall` 
## Configure
```vim
let g:swap_files_groups = [['src/{}.cpp', 'include/{}.h']]
```
