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
data = chain '5.txt',
    Fs.readFile
    Str.trim

    Str.split '\n'
    Arr.map compose [
        Str.replace /B|R/g, '1'
        Str.replace /F|L/g, '0'
        Num.parseBin
        (x)-> (x >> 3) * 8 + (x & 0b111)
    ]

part2 = chain [Arr.min(data) .. Arr.max(data)],
    Arr.filter (x)-> data.indexOf(x) == -1
    get 0

console.log "Part 1", Arr.max data
console.log "Part 2", part2