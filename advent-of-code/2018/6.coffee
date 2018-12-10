{chain, pluck} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

points = chain '6.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

    # Process into two integers
    Arr.map Str.split ' '
    Arr.map Arr.map (x)->parseInt x, 10
    Arr.map (x)->
        {
            x: x[0]
            y: x[1]
            points: 0
            infinite: false
        }

N = 401

# Part 1
closest = (a, b)->
    q = chain points,
        Arr.mapKeep ({x, y})->
            Math.abs(a - x) + Math.abs(b - y)
        Arr.sortABy (x)->x[1]
    if q[0][1] != q[1][1]
        return q[0][0]
    return null

for x in [-N..N]
    for y in [-N..N]
        # Find which one is closest and mark it
        c = closest x, y

        if not c?
            continue

        c.points++
        if x == -N || x == N || y == N || y == -N
            c.infinite = true

chain points,
    Arr.reject pluck 'infinite'
    Arr.maxBy pluck 'points'
    console.log

# Part 2
total = 0
for a in [-N..N]
    for b in [-N..N]
        sum = chain points,
            Arr.sumBy ({x, y})-> Math.abs(a - x) + Math.abs(b - y)
        if sum < 10000
            total += 1
console.log total
