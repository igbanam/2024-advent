vim9script

export def Sum(input: list<number>): number
  return input->reduce((a, v) => a + v, 0)
enddef

# ...because this is the poor man's Generics
def MapPred(input: list<any>, Pred: func(any): bool): list<bool>
  return input
    ->mapnew((_, icate) => Pred(icate))
    ->filter((_, j) => j)
enddef

export def All(input: list<any>, Pred: func(any): bool): bool
  return MapPred(input, Pred)
    ->len() == input->len()
enddef

export def Any(input: list<any>, Pred: func(any): bool): bool
  return MapPred(input, Pred)
    ->len() > 0
enddef

export def Contains(haystack: list<any>, needle: any): bool
  return haystack->index(needle) != -1
enddef

defcompile
