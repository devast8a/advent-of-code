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
data = chain '11.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'

step = (fn, C, data)->
    out = new Array(data.length).fill(0).map -> new Array(data[0].length).fill('.')

    for y in [0..data.length - 1]
        for x in [0..data[y].length - 1]
            count = 0
            for xi in [-1..1]
                for yi in [-1..1]
                    if xi == 0 and yi == 0 then continue
                    count += fn data, x, y, xi, yi

            if data[y][x] == 'L' and count == 0
                out[y][x] = '#'
            else if data[y][x] == '#' and count >= C
                out[y][x] = 'L'
            else
                out[y][x] = data[y][x]

    return out

solve = (data, count, fn)->
    for i in [0...250]
        data = step fn, count, data

    chain data,
        Arr.flatMap (x)->x
        Arr.groupBy (x)->x
        Map.get '#'
        get 'length'
        console.log

solve data, 4, (data, x, y, xi, yi)->
    x += xi
    y += yi
    if 0 <= y < data.length and 0 <= x < data[0].length and data[y][x] == '#'
        return 1
    return 0

solve data, 5, (data, x, y, xi, yi)->
    x += xi
    y += yi
    while 0 <= y < data.length and 0 <= x < data[0].length and data[y][x] == '.'
        x += xi
        y += yi

    if 0 <= y < data.length and 0 <= x < data[0].length and data[y][x] == '#'
        return 1
    return 0