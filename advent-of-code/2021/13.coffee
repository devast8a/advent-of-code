{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque, Set} = require 'sweet-coffee/all'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

aoc
.setup
    date: '2021/13'
    tests: [
        string: """
            6,10
            0,14
            9,10
            0,3
            10,4
            4,11
            6,0
            6,12
            4,1
            0,13
            10,12
            3,4
            3,0
            8,4
            1,10
            2,14
            8,10
            9,0

            fold along y=7
            fold along x=5
        """
        part1: 17
    ]
.solve (input)->
    [points, folds] = chain input,
        Str.trim
        Str.split '\n\n'
        Arr.map Str.split '\n'

    points = chain points,
        Arr.map compose [
            Str.split ","
            Arr.map Num.parseDec
            Vec2d.fromArray
        ]
        Set.fromArray

    part1 = 0
    for fold in folds
        d = fold[11]
        value = parseInt fold[13..]

        for point from points
            if point[d] > value
                points.delete point
                point[d] = 2*value - point[d]
                points.add point

        part1 = part1 or points.size

    grid = [1..6].map -> [1..35].fill(' ')
    for {x, y} from points
        grid[y][x] = '#'
    part2 = chain grid,
        Arr.map Str.join ""
        Str.join "\n"

    return {
        part1: part1
        part2: "\n" + part2
    }