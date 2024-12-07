vim9script

def PathFormat(fname: string): string
  return $'{expand("%:h")}/{fname}.in'
enddef

export def LoadInput(inputName: string): list<string>
  return inputName->PathFormat()->readfile()
enddef

defcompile
