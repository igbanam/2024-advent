vim9script

import "../00/solution.vim"
import "../00/utils/enumerable.vim"
import "libenumerable.vim" as leb

class MonkeySecret
  static def Mix(a: number, b: number): number
    return a->xor(b)
  enddef

  static def Prune(a: number): number
    return a % 16777216
  enddef

  static def MixAndPrune(a: number, b: number): number
    return a->Mix(b)->Prune()
  enddef

  static def Evolve_Step1(a: number): number
    return a->MixAndPrune(a * 64)
  enddef

  static def Evolve_Step2(a: number): number
    return a->MixAndPrune(a / 32)
  enddef

  static def Evolve_Step3(a: number): number
    return a->MixAndPrune(a * 2048)
  enddef

  static def Evolve(a: number): number
    return a->Evolve_Step1()
            ->Evolve_Step2()
            ->Evolve_Step3()
  enddef
endclass

class Buyer
  var initialSecret: number
  var pricesOffered: list<number>
  var pricesChanges: list<number>

  def new(secret: number)
    this.initialSecret = secret
    this.pricesChanges = [0]
  enddef

  def EvolveSecret(times: number): number
    var result = this.initialSecret
    for i in times->range()
      result = result->MonkeySecret.Evolve()
      this.pricesOffered->add(result % 10)
      if i == 0
        continue
      endif
      this.pricesChanges[i] = this.pricesOffered[i] - this.pricesOffered[i - 1]
    endfor
    return result
  enddef
endclass

class MonkeyMarket extends solution.AbstractSolution
  var buyers: list<Buyer>
  const evolutions: number = 2000
  var solver: func

  def new(inputfile: string, part: number)
    if part == 1
      this.solver = this.Part1
    else
      this.solver = this.Part2
    endif
    inputfile->this.ReadInput()
    this.ParseInput()
  enddef

  def ParseInput()
    for line in this.input
      this.buyers->add(Buyer.new(line->str2nr()))
    endfor
  enddef

  def Part1(): number
    return this.buyers
      ->mapnew((_, a) => a.EvolveSecret(this.evolutions))
      ->enumerable.Sum()
  enddef

  def Part2(): any
    this.buyers->foreach((_, b) => b.EvolveSecret(this.evolutions))
    var result = {}
    for buyer in this.buyers
      var changes = []
      for i in (this.evolutions - 4)->range()
        var change = buyer.pricesChanges[i : i + 3]
        if changes->index(change) == -1
          changes->add(change)
          if result->has_key(change->string())
            result[change->string()] = result[change->string()] + buyer.pricesOffered[i + 3]
          else
            result[change->string()] = buyer.pricesOffered[i + 3]
          endif
        endif
      endfor
    endfor
    echo result->max() - 1
    return 0
  enddef

  def Solve(): any
    return this.solver()
  enddef
endclass

MonkeyMarket.new('the-test', 2).Solve()
