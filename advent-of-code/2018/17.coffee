{_, chain, compose, curry, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Op = require 'sweet-coffee/op'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

AIR = 0
CLAY = 1
SOLID_WATER = 2
RUNNING_WATER = 3

map = Arr.filled [2000, 2000], 0

minX = 10000
maxX = 0
minY = 10000
maxY = 0

coordinates = chain '17.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'
    Arr.map Regex.exec /([xy])=(\d+), [xy]=(\d+)..(\d+)/

    Arr.forEach ([_, c, a, b1, b2])->
        a = parseInt a
        b1 = parseInt b1
        b2 = parseInt b2

        if c == 'x'
            minX = Math.min minX, a
            minY = Math.min minY, b1
            maxX = Math.max maxX, a
            maxY = Math.max maxY, b2

            for b in [b1..b2] then map[b][a] = CLAY
        else
            minX = Math.min minX, b1
            minY = Math.min minY, a
            maxX = Math.max maxX, b2
            maxY = Math.max maxY, a

            for b in [b1..b2] then map[a][b] = CLAY

# Water flow simulation
stack = [[500, 0]]
map[0][500] = RUNNING_WATER

findEdge = (x, y, d)->
    while true
        switch map[y][x]
            when CLAY then return x - d
            when undefined then return -1

        switch map[y + 1][x]
            when SOLID_WATER, CLAY then x += d
            else return -1

solidifyRow = (x, y)->
    xl = findEdge x, y, +1
    xr = findEdge x, y, -1

    # Can't soldify this row
    if xl == -1 or xr == -1
        return

    for x in [xl..xr]
        map[y][x] = SOLID_WATER

spread = (x, y)->
    switch map[y][x]
        when SOLID_WATER, CLAY
            return true
        when AIR
            map[y][x] = RUNNING_WATER
            stack.push [x, y]
    return false

height = map.length

while stack.length > 0
    [x, y] = stack.pop()

    if map[y][x] != RUNNING_WATER
        continue

    if y + 1 >= height
        continue
    
    if map[y + 1][x] == SOLID_WATER or map[y + 1][x] == CLAY
        a = spread x - 1, y
        b = spread x + 1, y
        if a or b
            solidifyRow x, y

    if map[y + 1][x] == AIR
        map[y + 1][x] = RUNNING_WATER
        stack.push [x, y]
        stack.push [x, y + 1]

solid_water = running_water = 0
for row, y in map
    if minY <= y <= maxY
        for tile, x in row
            switch tile
                when SOLID_WATER then solid_water += 1
                when RUNNING_WATER then running_water += 1

# Part 1
console.log solid_water + running_water

# Part 2
console.log solid_water
