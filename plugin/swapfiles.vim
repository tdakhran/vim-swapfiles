"" load plugin only once
if exists('g:swap_files_plugin_loaded')
  finish
endif

"" require python3 support
if !has("python3")
  echo "vim has to be compiled with +python3 to run this"
  finish
endif

"" require g:swap_files_groups in vimrc file
if !exists('g:swap_files_groups')
  echo "set g:swap_files_groups in .vimrc to use plugin"
  finish
endif

python3 << EOF
import vim
import pathlib
import re

# generate regex matcher
def compile_path_reg(template):
  prefix_path_reg = '.*/'
  filename_reg = '.*'
  return re.compile('(' + prefix_path_reg + ')' + template.format('(' + filename_reg + ')') + '$')

# find group and position in pattern group of provided path
def find_match(groups, path):
  for gid in range(len(groups)):
    for tid in range(len(groups[gid])):
      if (match := compile_path_reg(groups[gid][tid]).match(str(path))):
        prefix_path, filename = match.groups()
        return (prefix_path, filename, gid, tid)

  return None

# find next existing file in pattern group
def find_next(group, tid, prefix_path, filename):
  for id in range(tid + 1, tid + len(group)):
    idx = id % len(group)
    if (next_path := prefix_path / pathlib.Path(group[idx].format(filename))) and next_path.exists():
      return next_path
  return None

# finds which pattern group currently opened file matches to, then opens next existing file in matched pattern group 
def swap_files():
  groups = vim.eval('g:swap_files_groups')

  if (current := pathlib.Path(vim.current.buffer.name)) and (match := find_match(groups, current)):
    prefix_path, filename, gid, tid = match

    if (next_path := find_next(groups[gid], tid, prefix_path, filename)):
      vim.command(':edit {}'.format(next_path))

EOF

function! SwapFiles()
  python3 swap_files()
endfunction

command! -nargs=0 SwapFiles call SwapFiles()

let g:swap_files_plugin_loaded = 1
