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

data = chain '2.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

    Arr.map compose [
        Str.split '\t'
        Arr.map Num.parseDec
    ]

chain data,
    Arr.map (row)->
        min = Arr.min row
        max = Arr.max row

        return max - min

    Arr.sum
    console.log

chain data,
    Arr.map (row)->
        for x in row
            for y in row
                a = Math.max x, y
                b = Math.min x, y

                if x != y and a % b == 0
                    return a / b
        return 0

    Arr.sum
    console.log
