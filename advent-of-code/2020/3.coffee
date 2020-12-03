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
data = chain '3.txt',
    Fs.readFile
    Str.trim

    Str.split '\n'

slope = (ys, xs)->
    x = 0
    y = 0
    count = 0
    while y < (data.length - 1)
        y += ys
        x = (x + xs) % data[0].length

        if data[y][x] == "#"
            count += 1
    return count

part1 = slope 1, 3

part2  = slope 1, 1
part2 *= slope 1, 3
part2 *= slope 1, 5
part2 *= slope 1, 7
part2 *= slope 2, 1

clip part2