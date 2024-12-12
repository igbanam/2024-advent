vim9script

import "../00/solution.vim"
import "../00/utils/enumerable.vim"

class PlutonianPebbles extends solution.AbstractSolution
  var collection: dict<number>
  var iterations: number

  def new(inputfile: string, part: number)
    inputfile->this.ReadInput()
    this.ParseInput()
    if part == 1
      this.iterations = 25
    else
      this.iterations = 75
    endif
  enddef

  def ParseInput()
    this.input = this.input
      ->map((_, m) => m->split(' ')
                       ->map((_, n) => n->str2nr()))[0]

    this.input->foreach((_, m) => {
      if !this.collection->has_key(m)
        this.collection[m] = this.input->count(m)
      endif
    })
  enddef

  def Solve(): any
    for i in this.iterations->range()
      var tmp: dict<number>
      for [item, tally] in this.collection->items()
        if item == '0'
          tmp[1] = tmp->get(1, 0) + tally
        elseif item->len() % 2 == 0
          var mid = item->len() / 2
          var left = item->slice(0, mid)->str2nr()
          var right = item->slice(mid)->substitute('\v^0\zs0+', '', '')->str2nr()
          tmp[left] = tmp->get(left, 0) + tally
          tmp[right] = tmp->get(right, 0) + tally
        else
          var ym = 2024 * item->str2nr()
          tmp[ym] = tmp->get(ym) + tally
        endif
      endfor
      this.collection = tmp
    endfor
    return this.collection->values()->enumerable.Sum()
  enddef
endclass

echo PlutonianPebbles.new('the-test', 1).Solve()
