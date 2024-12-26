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

export def Blank2DGrid(ref: list<list<any>>, filler: any): list<list<any>>
    return ref
      ->len()
      ->range()
      ->mapnew((_, _) => [filler]->repeat(ref[0]->len()))
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

export def CoordsWithinMap(p: list<number>, arr: list<list<any>>): bool
  return AbstractPoint.new(p[0], p[1])->WithinMap(arr)
enddef

export def BFS(
    x: number,
    y: number,
    dim: list<number> = [0, 0],
    StepClause: func(number, number): bool = (_: number, _: number) => true,
    EndClause: func(number, number): bool = (_: number, _: number) => true): list<list<number>>
  var queue: list<list<any>> = [[x, y, [[x, y]]]] # Queue of [x, y, path]
  var visited: list<list<bool>> = dim[0]
    ->range()
    ->map((_, _) => [false]->repeat(dim[1]))

  while !queue->empty()
    var current = queue->remove(0)
    var cx = current[0]
    var cy = current[1]
    var path = current[2]

    if visited[cx][cy]
      continue
    endif
    visited[cx][cy] = true

    if EndClause(cx, cy)
      return path
    endif

    for direction in directions
      var dx = cx + direction[0]
      var dy = cy + direction[1]

      if StepClause(dx, dy)
        var new_path = path->copy()
        new_path->add([dx, dy])
        queue->add([dx, dy, new_path])
      endif
    endfor
  endwhile
  return [] # No path found
enddef

defcompile
