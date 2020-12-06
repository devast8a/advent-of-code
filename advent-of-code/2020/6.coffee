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
data = chain '6.txt',
    Fs.readFile
    Str.trim

chain data,
    Str.split '\n\n'
    Arr.map compose [
        Set.create
        Set.delete '\n'
        get 'size'
    ]
    Arr.sum
    console.log

chain data,
    Str.split '\n\n'
    Arr.map (list)->
        letters = list.split '\n'

        return chain list,
            Set.create
            Set.filter (letter)->
                letters.every (entry)-> entry.indexOf(letter) >= 0
            get 'size'
    Arr.sum
    console.log