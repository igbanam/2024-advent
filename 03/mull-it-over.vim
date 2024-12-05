vim9script

import "../00/solution.vim"
import "../00/utils.vim"

var shouldAdd = true

class MullItOver extends solution.AbstractSolution
  static var MULTIPLES = '\vmul\((\d+),(\d+)\)'
  static var CONDITIONAL_MULTIPLES = '\vmul\((\d+),(\d+)\)|do\(\)|don''t\(\)'
  def new(inputfile: string)
    this.ReadInput(inputfile)
  enddef

  def ExtractConditionalNumbers(idx: number, line: string): list<list<number>>
    var regex = CONDITIONAL_MULTIPLES
    var lastMatch = line->matchstrpos(regex, 0)
    var digits = []
    while lastMatch[1] != -1
      if lastMatch[0] == "do()"
        shouldAdd = true
      endif
      if lastMatch[0] == "don't()"
        shouldAdd = false
      endif
      if shouldAdd
        var m = lastMatch[0]->matchlist(regex)
        digits->add([m[1], m[2]]->map((_, v) => v->str2nr()))
      endif
      lastMatch = line->matchstrpos(regex, lastMatch[2])
    endwhile
    return digits
  enddef

  def ExtractNumbers(idx: number, line: string): list<list<number>>
    var lastMatch = line->matchstrpos(MULTIPLES, 0)
    var digits = []
    while lastMatch[1] != -1
      var m = lastMatch[0]->matchlist(MULTIPLES)
      digits->add([m[1], m[2]]->map((_, v) => v->str2nr()))
      lastMatch = line->matchstrpos(MULTIPLES, lastMatch[2])
    endwhile
    return digits
  enddef

  def Solve(): any
    return this.input
      ->mapnew(this.ExtractConditionalNumbers)
      ->map((_, v) => v->reduce((a, e) => a + (e[0] * e[1]), 0))
      ->utils.Sum()
  enddef
endclass

echo MullItOver.new('the-data').Solve()
