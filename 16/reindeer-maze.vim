vim9script

import "../00/solution.vim"
import "../00/utils.vim"
import "libenumerable.vim"

type Set = libenumerable.Set

const WALL = '#'

class ReindeerMaze extends solution.MazeSolution
  var solver: func

  def new(part: number)
    this.startChar = 'S'
    this.endChar = 'E'
    if part == 1
      this.solver = this.CheapestPathCost
    else
      this.solver = this.SpotsInCheapestPath
    endif
  enddef

  def ParseInput()
    this.input = getline(1, '$')
      ->filter((_, line) => line != '')
    this.grid = this.input
      ->mapnew((_, line) => line->split('\ze'))
  enddef

  def VisualizePath(path: list<list<number>>)
    var gridCopy = this.grid->deepcopy()
    for spot in path
      gridCopy[spot[0]][spot[1]] = '†'
    endfor
    gridCopy->utils.Visualize()
  enddef

  def Cost(path: list<list<number>>): number
    var cost = 0
    var last_dir = [0, 1]
    for i in (path->len() - 1)->range()
      var dx = path[i + 1][0] - path[i][0]
      var dy = path[i + 1][1] - path[i][1]
      if dx != last_dir[0] || dy != last_dir[1]
        cost += 1001
        last_dir = [dx, dy]
      else
        cost += 1
      endif
    endfor
    return cost
  enddef

  def CheapestPathCost(): number
    this.ParseInput()
    var startPoint = this.FindStart()
    var endPoint = this.FindEnd()
    var cheapestPath = utils.FindCheapestPath(this.grid, startPoint, endPoint, WALL)
    echo cheapestPath['cost']
    return 0
  enddef

  def SpotsInCheapestPath(): number
    # NOTE: This takes forever and a day to run with the "the-data" input.
    this.ParseInput()
    var startPoint = this.FindStart()
    var endPoint = this.FindEnd()
    var allPaths = utils.FindAllPaths(this.grid, startPoint, endPoint, WALL)
    var minCost = v:numbermax
    var pathsData = {}
    for i in allPaths->len()->range()
      var pathCost = this.Cost(allPaths[i])
      pathsData[i] = {}
      pathsData[i]['cost'] = pathCost
      pathsData[i]['path'] = allPaths[i]
      minCost = [minCost, pathCost]->min()
    endfor
    var goodSpots = Set.new()
    pathsData
      ->filter((k, v) => v['cost'] == minCost)
      ->foreach((_, v) => {
        v['path']->foreach((_, w) => goodSpots.Add(w))
      })
    echo goodSpots.items->len()
    return 0
  enddef

  def Solve(): any
    return this.solver()
  enddef
endclass

ReindeerMaze.new(2).Solve()
