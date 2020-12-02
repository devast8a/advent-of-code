{chain, get} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

DirectedGraph = require 'sweet-coffee/container/directed-graph'

graph = chain '7.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

    Arr.map compose [
        Regex.exec /Step (\w+) must be finished before step (\w+) can begin\./
        ([_, from, to])->[from, to]
    ]
    DirectedGraph.create.fromEdges

# Part 1
chain graph,
    DirectedGraph.topologicalSortBy Arr.minBy get 'id'
    get 'ordering'

    Arr.map get 'id'
    Str.join ""
    console.log

# Part 2
seconds = 0

chain graph.nodes,
    Map.values.forEach (node)->
        node.value = 61 + node.id.charCodeAt(0) - 'A'.charCodeAt(0)
    
chain graph,
    DirectedGraph.topologicalSortBy (ready)->
        ready = chain ready,
            Arr.sortABy get 'id'
            Arr.take 5

        {value} = Arr.minBy get('value'), ready
        seconds += value

        return chain ready,
            Arr.forEach (task)-> task.value -= value
            Arr.filter (task)-> task.value == 0

console.log seconds
