vim9script

import "./utils.vim"

export interface ISolution
  var input: any
  def ReadInput(filename: string)
  def ParseInput()
  def Solve(): any
endinterface

export abstract class AbstractSolution implements ISolution
  var input: any

  def ReadInput(filename: string)
    this.input = utils.LoadInput(filename)
  enddef

  def ParseInput()
    throw "Unimplemented"
  enddef

  def Solve(): any
    throw "Unimplemented"
  enddef
endclass

defcompile
