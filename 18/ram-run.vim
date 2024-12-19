vim9script

import "../00/solution.vim"
import "../00/utils.vim"

class RamRun extends solution.AbstractSolution
  var memsize: number
  var corrupt: list<list<number>>
  var visited: list<list<bool>>
  var avenues: list<list<list<number>>>
  var solver: func

  static final SIMS: number = 1024
  static final FREE: string = '.'
  static final DEAD: string = '#'
  static final FOOT: string = '•'

  def new(inputfile: string, part: number)
    if part == 1
      this.solver = this.FindPath
    else
      this.solver = this.FirstBlock
    endif

    if inputfile == 'the-data'
      this.memsize = 71
    else
      this.memsize = 7
    endif

    this.visited = this.memsize
      ->range()
      ->map((_, _) => [false]->repeat(this.memsize))

    inputfile->this.ReadInput()
    this.ParseInput()
  enddef

  def ParseInput()
    var stopIndex = [SIMS, this.input->len()]->min()
    var i = 0
    while i < stopIndex
      this.AddCorruptByte(this.input[i])
      i = i + 1
    endwhile
  enddef

  def ResetCorruption()
    this.corrupt = []
    for i in SIMS->range()
      this.AddCorruptByte(this.input[i])
    endfor
  enddef

  def AddCorruptByte(loc: string)
    var segments = loc
      ->split(",")
      ->map((_, coord) => coord->str2nr())
    this.corrupt->add([segments[1], segments[0]])
  enddef

  def Walk(x: number, y: number): list<list<number>>
    # BFS
    var queue: list<list<any>> = [[x, y, [[x, y]]]] # Queue of [x, y, path]
    var visited: list<list<bool>> = this.memsize
      ->range()
      ->map((_, _) => [false]->repeat(this.memsize))

    while !queue->empty()
      var current = queue->remove(0)
      var cx = current[0]
      var cy = current[1]
      var path = current[2]

      if visited[cx][cy]
        continue
      endif
      visited[cx][cy] = true

      if cx == cy && cx == this.memsize - 1
        return path
      endif

      for direction in utils.directions
        var dx = cx + direction[0]
        var dy = cy + direction[1]

        if dx >= 0 && dx < this.memsize && dy >= 0 && dy < this.memsize &&
            !visited[dx][dy] && this.corrupt->index([dx, dy]) == -1
          var new_path = path->copy()
          new_path->add([dx, dy])
          queue->add([dx, dy, new_path])
        endif
      endfor
    endwhile
    return [] # No path found
  enddef

  def FindPath(): number
    var path = this.Walk(0, 0)
    if path->empty()
      # echo "No path found"
      return -1
    endif

    return path->len() - 1
  enddef

  def FirstBlock(): string
    var low = SIMS
    var high = this.input->len() - 1
    var result = -1

    while low <= high
      var mid = (low + high) / 2
      this.ResetCorruption()
      for i in SIMS->range(mid + 1)
        this.AddCorruptByte(this.input[i])
      endfor
      var path = this.Walk(0, 0)
      if path->empty()
        result = mid
        high = mid - 1
      else
        low = mid + 1
      endif
    endwhile

    return this.input[result + 1]
  enddef

  def Solve(): any
    return this.solver()
  enddef
endclass

echo RamRun.new('the-data', 2).Solve()
