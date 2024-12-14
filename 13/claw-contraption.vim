vim9script

import "../00/solution.vim"
import "../00/utils/enumerable.vim"

class ClawContraption extends solution.AbstractSolution
  var part: number
  var equations: list<dict<number>>

  def new(inputfile: string, part: number)
    this.part = part
    this.ReadInput(inputfile)
    this.ParseInput()
  enddef

  def ParseInput()
    var equation = {}
    for i in this.input->len()->range()
      if this.input[i] =~ '^Button'
        var matches = this.input[i]->matchlist('\v(\w): X\+(\d+), Y\+(\d+)')
        if matches[1] == 'A'
          equation->extend({ 'ax': matches[2]->str2nr(), 'ay': matches[3]->str2nr() })
        else
          equation->extend({ 'bx': matches[2]->str2nr(), 'by': matches[3]->str2nr() })
        endif
      elseif this.input[i] =~ '^Prize'
        var matches = this.input[i]->matchlist('\vX\=(\d+), Y\=(\d+)')
        equation->extend({ 'tx': matches[1]->str2nr(), 'ty': matches[2]->str2nr() })
        this.equations->add(equation)
        equation = {}
      endif
    endfor
  enddef

  def Solve(): any
    # Cramer's Rule
    this.equations->len()
    return this.equations->mapnew((_, q) => {
      var  d = q['ax'] * q['by'] - q['bx'] * q['ay']
      var dx = q['tx'] * q['by'] - q['bx'] * q['ty']
      var dy = q['ax'] * q['ty'] - q['tx'] * q['ay']
      var x = dx / d
      var y = dy / d
      if d != 0 && x < 100 && y < 100
        return (dx / d * 3) + (dy / d)
      else
        return 0
      endif
    })->enumerable.Sum()
  enddef
endclass

echo ClawContraption.new('the-test', 1).Solve()
