vim9script

import "../00/solution.vim"

def VerticalSlice(a: list<list<any>>, x: number, y: number, span: number = 0): list<any>
  var result = []
  var _span: number
  if span == 0
    _span = a->len()
  else
    _span = span
  endif
  for r in _span->range()
    if x + r < 0 || x + r >= a->len()
      continue
    endif
    result->add(a[x + r][y])
  endfor
  return result
enddef

def DiagonalSlices(a: list<list<any>>, x: number, y: number, span: number = 0): list<list<any>>
  var _span: number
  var topLeft: list<any>
  var botLeft: list<any>
  var botRight: list<any>
  var topRight: list<any>
  if span == 0
    _span = a->len()
  else
    _span = span
  endif
  var i = x
  var j = y
  for idx in _span->range()
    if !(x - idx < 0 || y - idx < 0)
      topLeft->add(a[x - idx][y - idx])
    endif
    if !(x + idx >= a->len() || y - idx < 0)
      botLeft->add(a[x + idx][y - idx])
    endif
    if !(x + idx >= a->len() || y + idx >= a[0]->len())
      botRight->add(a[x + idx][y + idx])
    endif
    if !(x - idx < 0 || y + idx >= a[0]->len())
      topRight->add(a[x - idx][y + idx])
    endif
  endfor
  return [topLeft, topRight, botLeft, botRight]
enddef

class NumberWrapper
  public var value: number

  def Increment()
    this.value = this.value + 1
  enddef
endclass

class CeresSearch extends solution.AbstractSolution
  var part: number
  var pivot: string
  var needle: string
  var scanner: func: list<any>

  def new(inputfile: string, part: number = 1)
    inputfile->this.ReadInput()
    this.ParseInput()
    this.part = part
    if part == 1
      this.pivot = 'X'
      this.needle = 'XMAS'
      this.scanner = this.ScanDirections
    elseif part == 2
      this.pivot = 'A'
      this.needle = 'MAS'
      this.scanner = this.ScanEnvironment
    endif
  enddef

  def ParseInput()
    this.input->map((_, v) => v->split('\zs'))
  enddef

  def ScanDirections(x: number, y: number): list<any>
    var localView = []
    var span = this.needle->len()
    localView->add(this.input[x]->slice(y, y + span))
    localView->add(this.input[x]->slice(y - (span - 1), y + 1)->reverse())
    localView->add(this.input->VerticalSlice(x, y, span))
    localView->add(this.input->VerticalSlice(x - (span - 1), y, span)->reverse())
    this.input->DiagonalSlices(x, y, span)->foreach((_, l) => localView->add(l))
    return localView
  enddef

  def ScanEnvironment(x: number, y: number): list<any>
    var result = []
    if !(x - 1 < 0 || y - 1 < 0 || x + 1 >= this.input->len() || y + 1 >= this.input[0]->len())
      var fs = [this.input[x - 1][y - 1], this.input[x][y], this.input[x + 1][y + 1]]
      var bs = [this.input[x - 1][y + 1], this.input[x][y], this.input[x + 1][y - 1]]
      result->add([fs, bs])
      result->add([fs->deepcopy()->reverse(), bs->deepcopy()->reverse()])
      result->add([fs->deepcopy(), bs->deepcopy()->reverse()])
      result->add([fs->deepcopy()->reverse(), bs->deepcopy()])
    endif
    return result
  enddef

  def Solve(): any
    var xc = 0
    for i in this.input->len()->range()
      for j in this.input[0]->len()->range()
        if this.input[i][j] != this.pivot
          continue
        endif
        if this.part == 1
          xc = xc + this.scanner(i, j)
            ->filter((_, v) => v->join('') == this.needle)
            ->len()
        elseif this.part == 2
          var scannerResult = this.scanner(i, j)
            ->filter((_, p) => {
              var joined = p->flattennew()
              return joined->count('M') == 2 &&
                joined->count('S') == 2 &&
                p[0][0] != p[0][-1]
            })
          if !empty(scannerResult)
            xc = xc + 1
          endif
        else
          throw "Unknown part!"
        endif
      endfor
    endfor
    return xc
  enddef
endclass

echo CeresSearch.new('the-data', 1).Solve()
