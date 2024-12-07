vim9script

export def Sum(input: list<number>): number
  return input->reduce((a, v) => a + v, 0)
enddef

defcompile
