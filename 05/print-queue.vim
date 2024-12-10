vim9script

import "../00/solution.vim"
import "../00/utils/enumerable.vim"

def TopologicalSort(graph: dict<list<string>>): list<string>
  var inDegree: dict<number> = {}
  var result: list<string> = []
  var queue: list<string> = []

  # Initialize in-degree of all nodes to 0
  for [node, neighbors] in graph->items()
    if !inDegree->has_key(node)
      inDegree[node] = 0
    endif
    neighbors->foreach((_, i) => {
      inDegree[i] = inDegree->get(i, 0) + 1
    })
  endfor

  # Find all nodes with in-degree 0 and add to the queue
  for [node, degree] in inDegree->items()
    if degree == 0
      queue->add(node)
    endif
  endfor

  # Perform Kahn's algorithm
  while queue->len() > 0
    var current = queue->remove(0) # Dequeue node
    result->add(current)
    if graph->has_key(current)
      for neighbor in graph[current]
        inDegree[neighbor] -= 1
        if inDegree[neighbor] == 0
          queue->add(neighbor)
        endif
      endfor
    endif
  endwhile

  # Check cycle
  if result->len() != inDegree->len()
    throw "Cyclic Graph! …should be a DAG"
  endif

  return result
enddef

class PrintQueue extends solution.AbstractSolution
  var part: number
  var ordering: list<list<number>>
  var updates: list<list<number>>
  var solver: func(): any

  def new(inputfile: string, part: number)
    inputfile->this.ReadInput()
    this.ParseInput()

    if part == 1
      this.solver = this.Part1
    else
      this.solver = this.Part2
    endif
  enddef

  def ParseInput()
    var inputBreak = this.input->index('')
    this.ordering = this.input
      ->deepcopy()
      ->slice(0, inputBreak)
      ->map((_, i) => i->split('|')->map((_, j) => j->str2nr()))
    this.updates = this.input
      ->deepcopy()
      ->slice(inputBreak + 1)
      ->map((_, i) => i->split(',')->map((_, j) => j->str2nr()))
  enddef

  def ValidMapper(): func(number, list<number>): bool
    return (_: number, l: list<number>) => this.Valid(l)
  enddef

  def InvalidMapper(): func(number, list<number>): bool
    return (_: number, l: list<number>) => !this.Valid(l)
  enddef

  def Valid(l: list<number>): bool
    for rule in this.ordering
      if l->enumerable.Contains(rule[0]) &&
          l->enumerable.Contains(rule[1]) &&
          l->index(rule[0]) > l->index(rule[1])
        return false
      endif
    endfor
    return true
  enddef

  def Part1(): any
    echo this.updates
      ->filter(this.ValidMapper())
      ->mapnew((_, update) => {
        var mid = update->len() / 2
        if update->len() % 2 == 0
          return update[mid - 1]
        else
          return update[mid]
        endif
      })
      ->enumerable.Sum()
    return 0
  enddef

  def RuleGraph(l: list<number>): dict<list<string>>
    var result = {}
    for rule in this.ordering
      if !rule->enumerable.All((f: any): bool => l->enumerable.Contains(f))
        continue
      endif
      if result->has_key(rule[0])
        result[rule[0]]->add(rule[1]->string())
      else
        result[rule[0]] = [rule[1]->string()]
      endif
    endfor
    return result
  enddef

  def RuleGraphMapper(): func(number, list<number>): dict<list<string>>
    return (_: number, l: list<number>) => this.RuleGraph(l)
  enddef

  def Part2(): any
    echo this.updates
      ->filter(this.InvalidMapper())
      ->mapnew(this.RuleGraphMapper())
      ->mapnew((_, updateRuleGraph) => updateRuleGraph->TopologicalSort())
      ->mapnew((_, update) => {
        var mid = update->len() / 2
        if update->len() % 2 == 0
          return update[mid - 1]
        else
          return update[mid]
        endif
      })
      ->map((_, i) => i->str2nr())
      ->enumerable.Sum()
    return 0
  enddef

  def Solve(): any
    return this.solver()
  enddef
endclass

PrintQueue.new('the-test', 2).Solve()
