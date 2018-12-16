{chain, get} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'

points = chain '10.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

    Arr.map Regex.exec /position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>/
    Arr.map ([_, px, py, vx, vy])->
        {
            position: {
                x: parseInt px, 10
                y: parseInt py, 10
            }
            velocity: {
                x: parseInt vx, 10
                y: parseInt vy, 10
            }
        }

addPosition = ({position, velocity})->
    position.x += velocity.x
    position.y += velocity.y

getBoundingBox = (points)->
    minX = points[0].position.x
    minY = points[0].position.y
    maxX = points[0].position.x
    maxY = points[0].position.y

    chain points,
        Arr.forEach ({position})->
            if position.x < minX then minX = position.x
            if position.x > maxX then maxX = position.x
            if position.y < minY then minY = position.y
            if position.y > maxY then maxY = position.y

    return {
        left: minX,
        right: maxX,
        top: minY,
        bottom: maxY,
    }

sizes = []
for i in [0..100000]
    box = chain points,
        Arr.forEach addPosition
        getBoundingBox

    {left, right, top, bottom} = box
    size = (right - left) * (bottom - top)

    sizes.push [i, size]
    
    if i == 10510
        height = bottom - top
        width = right - left

        output = [0..height].map ->
            [0..width].fill ' '

        console.log left, right
        console.log top, bottom

        for {position} in points
            output[position.y - top][position.x - left] = '#'

        output.forEach (x)->
            console.log x.join ''

chain sizes,
    Arr.minBy get 1
    console.log
