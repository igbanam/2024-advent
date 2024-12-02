vim9script

import "../00/solution.vim"

class HystorianHysteria extends solution.AbstractSolution
  var left_list: list<number>
  var right_list: list<number>

  def new(inputfile: string)
    inputfile->this.ReadInput()

    this.ParseInput()
  enddef

  def ParseInput()
    for line in this.input
      var parts = line->split(' ')->filter((_, v) => v != '')
      this.left_list->add(parts[0]->str2nr())
      this.right_list->add(parts[1]->str2nr())
    endfor

    this.left_list->sort()
    this.right_list->sort()
  enddef

  def Solve_Part1(): any
    var diff_sum: number = 0

    for idx in range(this.left_list->len())
      if this.left_list[idx] > this.right_list[idx]
        diff_sum = diff_sum + (this.left_list[idx] - this.right_list[idx])
      elseif this.right_list[idx] > this.left_list[idx]
        diff_sum = diff_sum + (this.right_list[idx] - this.left_list[idx])
      else
        # equality case
        # do nothing
      endif
    endfor

    return diff_sum
  enddef

  def Solve_Part2(): any
    var tally: dict<number>
    this.left_list->foreach((_, v) => {
        if !tally->has_key(v)
          tally[v] = this.right_list->deepcopy()->filter((_, a) => v == a)->len()
        endif
    })
    # echo tally
    return this.left_list->deepcopy()->reduce((a, v) => a + (v * tally[v]), 0)
  enddef

  def Solve(): any
    return this.Solve_Part2()
  enddef
endclass

echo HystorianHysteria.new('part1').Solve()

# :try | throw "oops" | catch /^oo/ | echo "caught" | endtry
