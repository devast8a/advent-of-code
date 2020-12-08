{_, chain, compose, curry, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Op = require 'sweet-coffee/op'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'
Math = require 'sweet-coffee/math'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

# Read and format input
bags = chain '7.txt',
    Fs.readFile
    Str.trim
    
    Str.split '\n'
    Arr.reject Str.contains 'no other bags'

    Arr.flatMap compose [
        Str.replace /\sbags?/g, ''
        Str.split ' contain '
        ([first, contents])->
            chain contents,
                Regex.execAll /(\d+) ([\w\s]+)/g
                Arr.map ([_, count, second])-> {from: first, to: second, data: count}
    ]
    DirectedGraph.create.fromEdges

gold = bags.getNode 'shiny gold'

# Part 1
chain bags,
    DirectedGraph.reverse
    DirectedGraph.depthFirst 'shiny gold'
    get 'length'
    Op.sub 1
    console.log

# Part 2
chain bags,
    DirectedGraph.map compose [
        Arr.sumBy (edge)-> edge.data * edge.result
        Op.add 1
    ]
    Map.get 'shiny gold'
    Op.sub 1
    console.log