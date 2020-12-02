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

chain '1.txt',
    # Read input
    Fs.readFile
    Str.trim

    Str.split '\n'

    Arr.map Num.parseDec

    (numbers)=>
        for x in numbers
            for y in numbers
                if x + y == 2020
                    console.log x * y

        for x in numbers
            for y in numbers
                for z in numbers
                    if x + y + z == 2020
                        console.log x * y * z