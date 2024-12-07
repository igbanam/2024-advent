vim9script

import "../00/solution.vim"
import "../00/utils/enumerable.vim"

class Functors
  static def Add(a_: number, b_: number): number
    return a_ + b_
  enddef

  static def Multiply(a_: number, b_: number): number
    return a_ * b_
  enddef

  static def Join(a_: number, b_: number): number
    return str2nr(a_->string() .. b_->string())
  enddef
endclass

class Walker
  var destination: number
  var steps: list<number>
  var pathTrod: list<string>

  var functors = {
    '+': Functors.Add,
    '*': Functors.Multiply
  }

  def new(d_: number, s_: list<number>, p_: number = 1)
    this.destination = d_
    this.steps = s_
    if p_ == 2
      this.functors['||'] = Functors.Join
    endif
  enddef

  def Step(loc: number, currentResult: number, operators: string)
    if loc == this.steps->len()
      if currentResult == this.destination
        this.pathTrod->add(operators)
      endif
      return
    endif

    this.functors->foreach((k_, v_) => {
      this.Step(loc + 1, v_->call([currentResult, this.steps[loc]]), operators .. k_)
    })
  enddef

  def Walk(): any
    this.Step(1, this.steps[0], '')

    if this.pathTrod->len() > 0
      return this.pathTrod
    else
      return "No solution"
    endif
  enddef
endclass

class BridgeRepair extends solution.AbstractSolution
  var part: number

  def new(inputfile: string, part: number = 1)
    this.part = part
    this.ReadInput(inputfile)
    this.ParseInput()
  enddef

  def ParseInput()
    this.input
      ->map((_, v) => v->split(':'))
      ->map((_, v) => v->map((_, w) => w->split(' ')
                                        ->filter((_, x) => x != '')
                                        ->map((_, y) => y->str2nr())))
  enddef

  def Solve(): any
    var reachable = []
    for i in this.input->len()->range()
      var pathsTrod = Walker.new(this.input[i][0][0], this.input[i][1], this.part).Walk()
      if pathsTrod->type() == []->type()
        reachable->add(this.input[i][0][0])
      endif
    endfor
    return reachable->enumerable.Sum()
  enddef
endclass

echo BridgeRepair.new('the-test', 2).Solve()
