{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/5'
    tests: [
        {
            string: """
                0,9 -> 5,9
                8,0 -> 0,8
                9,4 -> 3,4
                2,2 -> 2,1
                7,0 -> 7,4
                6,4 -> 2,0
                0,9 -> 2,9
                3,4 -> 1,4
                0,0 -> 8,8
                5,5 -> 8,2
            """
            part1: 5
            part2: 12
        }
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'

    lines = chain input,
        Arr.map compose [
            Regex.execAll /(\d+)/g
            Arr.flatten
            Arr.map Num.parseDec
            ([x1, y1, x2, y2]) -> {
                from: {x: x1, y: y1},
                to: {x: x2, y: y2}
            }
        ]
    
    points = chain lines,
        Arr.flatMap ({from, to}) -> [from, to]

    height = chain points,
        Arr.map get 'y'
        Arr.max
        Op.add 1

    width = chain points,
        Arr.map get 'x'
        Arr.max
        Op.add 1

    grid = new Array(height * width).fill(0)

    for {from, to} in lines
        if from.x == to.x
            # Vertical line
            x = from.x
            for y in [from.y..to.y]
                grid[y * width + x]++
        else if from.y == to.y
            # Horizontal line
            y = from.y
            for x in [from.x..to.x]
                grid[y * width + x]++
                

    part1 = chain grid,
        Arr.countBy Op.lt 1

    for {from, to} in lines
        if from.x != to.x and from.y != to.y
            left = Arr.minBy get('x'), [from, to]
            right = Arr.maxBy get('x'), [from, to]

            end = right.x - left.x

            if left.y < right.y
                # Diagonal /
                for i in [0..end]
                    x = left.x + i
                    y = left.y + i
                    grid[y * width + x]++
            else
                # Diagonal \
                for i in [0..end]
                    x = left.x + i
                    y = left.y - i
                    grid[y * width + x]++

    part2 = chain grid,
        Arr.countBy Op.gt _, 1

    return {
        part1
        part2
    }
