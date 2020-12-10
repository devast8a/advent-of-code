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
data = chain '10.txt',
    Fs.readFile
    Str.trim
    
    Str.split '\n'
    Arr.map compose [
        Num.parseDec
    ]
    Arr.sortA

data.unshift 0
data.push Arr.max(data) + 3

chain data,
    Arr.map (value, index, array)-> array[index + 1] - value
    Arr.groupBy (x)-> x
    (map)-> map.get(1).length * map.get(3).length
    console.log

chain data,
    Arr.flatMap (current)->
        chain data,
            Arr.filter (next)-> 1 <= next - current <= 3
            Arr.map (next)-> [current, next]
    DirectedGraph.create.fromEdges
    DirectedGraph.reduce (edges)->
        chain edges,
            Arr.sumBy get 'result'
            (x)-> x or 1
    Map.get 0
    console.log