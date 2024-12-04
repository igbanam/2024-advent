vim9script

import "../00/solution.vim"
import "../00/utils/math.vim"

var _withDampner: bool

def GetSlopeDirection(left: number, right: number): string
  if left > right
    return "decreasing"
  elseif right > left
    return "increasing"
  else
    return "flat"
  endif
enddef

def SameSlope(records: list<number>, withDampner: bool = false): bool
  var result = true
  var originalSlopeDirection: string
  var problemPoints: list<number>
  for i in records->len()->range()
    if i == 0
      originalSlopeDirection = GetSlopeDirection(records[i], records[i + 1])
      continue
    endif
    if i > records->len() - 2
      break
    endif
    var currentSlopeDirection = GetSlopeDirection(records[i], records[i + 1])
    if originalSlopeDirection != currentSlopeDirection && currentSlopeDirection != "flat"
      if withDampner
        result = false
        problemPoints->add(i)
      else
        return false
      endif
    endif
  endfor

  if withDampner
    result = problemPoints->Dampen(SameSlope)
  endif
  return result
enddef

def GradualSlope(records: list<number>, withDampner: bool = false): bool
  var result = true
  var problemPoints: list<number>
  for i in records->len()->range()
    if i > records->len() - 2
      break
    endif
    var distance = math.Abs(records[i] - records[i + 1])
    if distance < 1 || distance > 3
      if withDampner
        result = false
        problemPoints->add(i)
      else
        return false
      endif
    endif
  endfor

  if withDampner
    result = problemPoints->Dampen(GradualSlope)
  endif
  return result
enddef

def Dampen(arr: list<number>, Rechecker: func): bool
  if arr->len() > 1
    return false
  endif
  return Rechecker(arr)
enddef

class RedNosed_Reports extends solution.AbstractSolution
  def new(inputfile: string)
    inputfile->this.ReadInput()
  enddef

  def Safe(idx: number, line: string): bool
    var records: list<number> = line->split()->map((_, v) => v->str2nr())
    var hasSameSlope = records->SameSlope(_withDampner)
    var hasGradualSlope = records->GradualSlope(_withDampner)
    return hasSameSlope && hasGradualSlope
  enddef

  def _Solution(): any
    return this.input
      ->map(this.Safe)
      ->filter((_, q) => q)
      ->len()
  enddef

  def Solve_Part1(): any
    return this._Solution()
  enddef

  def Solve_Part2(): any
    _withDampner = true
    return this._Solution()
  enddef

  def Solve(): any
    return this.Solve_Part1()
  enddef
endclass

echo RedNosed_Reports.new('the-test').Solve()
