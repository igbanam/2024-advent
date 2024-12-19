vim9script

def PathFormat(fname: string): string
  return $'{expand("%:h")}/{fname}.in'
enddef

export def LoadInput(inputName: string): list<string>
  return inputName->PathFormat()->readfile()
enddef

export def Visualize(grid: list<list<any>>, logfile: string = '')
  var topBar = '-'->repeat(grid[0]->len())
  if logfile->empty()
    echo topBar
  else
    writefile([topBar], logfile, "a")
  endif
  for line in grid
    var content = line->join('')
    if logfile->empty()
      echo content
    else
      writefile([content], logfile, "a")
    endif
  endfor
enddef

export const directions = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0]
]

export const compass = {
  'r': [0, 1],
  'l': [0, -1],
  'd': [1, 0],
  'u': [-1, 0]
}

export class AbstractPoint
  public var x: number
  public var y: number
endclass

export def WithinMap(p: AbstractPoint, arr: list<list<any>>): bool
  return p.x >= 0 &&
    p.y >= 0 &&
    p.x < arr->len() &&
    p.y < arr[0]->len()
enddef

defcompile
