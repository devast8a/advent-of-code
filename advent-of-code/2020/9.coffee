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
data = chain '9.txt',
    Fs.readFile
    Str.trim
    
    Str.split '\n'
    Arr.map Num.parseDec

preambleLength = 25
part1 = chain data,
    Arr.window preambleLength + 1
    Arr.findBy ([...numbers, last])->
        chain numbers,
            Arr.map Op.sub _, last
            Arr.none Arr.contains _, numbers
    get preambleLength
console.log part1

for s in [0...data.length]
    for e in [(s + 2)...data.length]
        if Arr.sum(data[s...e]) == part1
            value = data[s...e]
            console.log Arr.min(value) + Arr.max(value)