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

clip = (text)=>
    require('child_process').spawn('clip').stdin.end(text.toString())
    console.log(text)

# Read and format input
data = chain '2.txt',
    Fs.readFile
    Str.trim

    Str.split '\n'
    Arr.map Regex.exec /(\d+)-(\d+) (\w): (\w+)/

# Part 1
part1 = chain data,
    Arr.filter ([_, a, b, c, d])=>
        a = parseInt a
        b = parseInt b

        num = chain d,
            Str.split ''
            Arr.groupBy (x)=>x
            Map.get c
            get 'length'

        return a <= num <= b
    get 'length'

# Part 2
part2 = chain data,
    Arr.filter ([_, a, b, c, d])=>
        a = parseInt a
        b = parseInt b

        a = d.charAt a - 1
        b = d.charAt b - 1

        return ((a == c) or (b == c)) and (a != b)
    get 'length'

console.log "Part 1 #{part1}"
console.log "Part 2 #{part2}"
# clip part1