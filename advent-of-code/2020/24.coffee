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
grid = new Array 1000 * 1000
grid.fill 0

chain '24.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'
    Arr.map compose [
        Str.split /(ne|nw|se|sw|e|w)/g
        Arr.filter (x)-> x.length > 0
        (seq)->
            x = 500
            y = 500

            for direction in seq
                switch direction
                    when 'e'  then x += 1
                    when 'w'  then x -= 1
                    when 'ne' then [x, y] = [x + (y+0)%2, y - 1]
                    when 'nw' then [x, y] = [x - (y+1)%2, y - 1]
                    when 'se' then [x, y] = [x + (y+0)%2, y + 1]
                    when 'sw' then [x, y] = [x - (y+1)%2, y + 1]

            index = 1000 * y + x
            grid[index] = 1 - grid[index]

    ]

neighbors = (x, y)->
    W = 1 - y % 2
    E = y % 2
    return [[x - 1, y], [x + 1, y], [x - W, y - 1], [x - W, y + 1], [x + E, y - 1], [x + E, y + 1]]

step = (input, size)->
    output = new Array input.length
    output.fill 0

    for y in [0...size]
        for x in [0...size]
            count = 0

            output[y * size + x] = input[y * size + x]

            for [nx, ny] in neighbors x, y
                if 0 <= nx < size and 0 <= ny < size
                    count += input[ny * size + nx]

            if input[y * size + x] == 1
                if count == 0 or count > 2
                    output[y * size + x] = 0
            else
                if count == 2
                    output[y * size + x] = 1
    return output

console.log grid.filter((x)-> x == 1).length
for i in [1..100]
    grid = step grid, 1000
console.log grid.filter((x)-> x == 1).length