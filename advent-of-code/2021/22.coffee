{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
{Vec3, Box3} = require 'sweet-coffee/vec'
aoc = require '../aoc'
CSG = require '@jscad/modeling'

aoc
.setup
    date: '2021/22'
    tests: []
.solve (input)->
    commands = chain input,
        Str.trim
        Str.split '\n'
        Arr.mapKeep compose [
            Regex.extractAll /-?\d+/g
            Arr.map Num.parseDec
        ]

    previous = null

    for [operation, region] in commands
        lower = Vec3.create region[0], region[2], region[4]
        upper = Vec3.create region[1], region[3], region[5]

        size   = Vec3.addNum(Vec3.sub(upper, lower), 1)
        center = Vec3.add(Vec3.divNum(size, 2), lower)

        next = CSG.primitives.cuboid
            center: Vec3.toArray center
            size: Vec3.toArray size

        if previous == null
            previous = next
        else
            if operation.includes 'on'
                previous = CSG.booleans.union previous, next
            else
                previous = CSG.booleans.subtract previous, next

    # We lose precision with answers. Try rounding up, rounding up and adding one.
    return {
        part2: CSG.measurements.measureAggregateVolume previous
    }