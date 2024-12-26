vim9script

import "../00/utils.vim"

def ParseInput(): list<string>
  return getline(1, '$')->filter((_, line) => line != '')
enddef

def FindStart(grid: list<string>): list<number>
  var y = 0
  while y < grid->len()
    var x = grid[y]->stridx('^')
    if x >= 0
      return [x, y]
    endif
    y += 1
  endwhile
  return [0, 0]
enddef

def MoveDir(dir: number): list<number>
  var dirs = [[0, -1], [1, 0], [0, 1], [-1, 0]]
  return dirs[dir]
enddef

def InBounds(pos: list<number>, grid: list<string>): bool
  return pos[0] >= 0 &&
    pos[0] < grid[0]->len() &&
    pos[1] >= 0 &&
    pos[1] < grid->len()
enddef

def Part1(grid: list<string>): number
  var pos = grid->FindStart()
  var dir = 0
  var seen = {}
  seen[$'{pos[0]},{pos[1]}'] = 1
  
  while true
    var move = MoveDir(dir)
    var next = [pos[0] + move[0], pos[1] + move[1]]

    if !next->InBounds(grid)
      break
    endif

    if grid[next[1]][next[0]] == '#'
      dir = (dir + 1) % 4
      continue
    endif

    pos = next
    seen[$'{pos[0]},{pos[1]}'] = 1
  endwhile

  return seen->len()
enddef

def HasLoop(grid: list<string>, obstacle: list<number>): bool
  var pos = grid->FindStart()
  var dir = 0
  var seen = {}
  var steps = 0
  var max_steps = len(grid) * len(grid[0]) * 4  # Maximum possible steps before loop must occur
  
  while steps < max_steps
    var key = $'{pos[0]},{pos[1]},{dir}'
    if seen->has_key(key)
      return true
    endif
    seen[key] = 1

    var move = dir->MoveDir()
    var next = [pos[0] + move[0], pos[1] + move[1]]

    if !next->InBounds(grid)
      return false
    endif

    if next[0] == obstacle[0] && next[1] == obstacle[1] || grid[next[1]][next[0]] == '#'
      dir = (dir + 1) % 4
    else
      pos = next
    endif
    steps += 1
  endwhile

  return true
enddef

def Part2(grid: list<string>): number
  var start = grid->FindStart()
  var count = 0
  var y = 0

  while y < grid->len()
    var x = 0
    while x < grid[0]->len()
      if [x, y] != [start[0], start[1]] && grid[y][x] != '#'
        if grid->HasLoop([x, y])
          count += 1
        endif
      endif
      x += 1
    endwhile
    y += 1
  endwhile

  return count
enddef

def Main()
  var grid = ParseInput()
  echo 'Part 1:' Part1(grid)
  echo 'Part 2:' Part2(grid)
enddef

Main()
