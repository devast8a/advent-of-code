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

data = chain '8.txt',
    # Read input
    Fs.readFile
    Str.trim
    Regex.extractAll /-?\d+/g
    Arr.map Num.parseDec

parse = (index, data)->
    countChildren = data[index]
    countData = data[index + 1]
    index += 2

    children = []
    part1 = 0
    part2 = 0

    for i in [0...countChildren]
        result = await parse index, data
        children.push result

        index = result.index
        part1 += result.part1

    for i in [0...countData]
        part1 += data[index]

        if countChildren > 0
            child = data[index] - 1
            if child >= 0 and child < children.length
                part2 += children[child].part2
        else
            part2 += data[index]

        index += 1

    return {
        index: index
        part1: part1
        part2: part2
    }

parse(0, data).then console.log
