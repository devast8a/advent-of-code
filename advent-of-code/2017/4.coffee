{chain, compose, pluck} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

data = chain '4.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'
    Arr.map Str.split ' '

    Arr.mapKeep Set.create
    Arr.filter ([x, y])-> x.length == y.size
    pluck 'length'
    console.log

data = chain '4.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'
    Arr.map Str.split ' '

    Arr.map Arr.map compose [
        Str.split ''
        Arr.sortA
        Str.join ''
    ]
    Arr.mapKeep Set.create
    Arr.filter ([x, y])-> x.length == y.size
    pluck 'length'
    console.log
