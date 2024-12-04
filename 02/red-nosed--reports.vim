vim9script

import "../00/solution.vim"
import "../00/utils/math.vim"

def GetSlopeDirection(left: number, right: number): string
  if left > right
    return "decreasing"
  elseif right > left
    return "increasing"
  else
    return "flat"
  endif
enddef

def SameSlope(records: list<number>): bool
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
      return false
    endif
  endfor
  return result
enddef

def GradualSlope(records: list<number>): bool
  var result = true
  var problemPoints: list<number>
  for i in records->len()->range()
    if i > records->len() - 2
      break
    endif
    var distance = math.Abs(records[i] - records[i + 1])
    if distance < 1 || distance > 3
      return false
    endif
  endfor
  return result
enddef

class RedNosed_Reports extends solution.AbstractSolution
  def new(inputfile: string)
    inputfile->this.ReadInput()
  enddef

  def Safe1(idx: number, line: string): bool
    var records: list<number> = line->split()->map((_, v) => v->str2nr())
    var hasSameSlope = records->SameSlope()
    var hasGradualSlope = records->GradualSlope()
    return hasSameSlope && hasGradualSlope
  enddef

  def Safe2(idx: number, line: string): bool
    var records: list<number> = line->split()->map((_, v) => v->str2nr())
    return records
      ->len()->range()                                                 # Get indices to pop
      ->mapnew((_, v) => {
        var recordsCopy = records->deepcopy()                          # keep original records
        recordsCopy->remove(v)                                         # pop value at index
        return recordsCopy->SameSlope() && recordsCopy->GradualSlope() # check safety
      })
      ->filter((_, v) => v)                                            # these two lines basically...
      ->len() > 0                                                      # ...define Enumerable#any()
  enddef

  def Solution(PartSafety: func): any
    return this.input
      ->map(PartSafety)
      ->filter((_, q) => q)
      ->len()
  enddef

  def Solve(): any
    return this.Solution(this.Safe2)
  enddef
endclass

echo RedNosed_Reports.new('the-data').Solve()
