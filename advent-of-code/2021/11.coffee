{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/11'
    tests: [
        string: """
            5483143223
            2745854711
            5264556173
            6141336146
            6357385478
            4167524645
            2176841721
            6882881134
            4846848554
            5283751526
        """
        part1: 1656
        part2: 195
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Str.split ''
        Arr.map Arr.map Num.parseDec

    height = input.length - 1
    width = input[0].length - 1

    flashes = 0
    step = (input)->
        input = Arr.map Op.add(1), input
        update = true
        while update
            update = false

            for row, y in input
                for value, x in row
                    if typeof(value) != 'string' and value > 9
                        update = true
                        flashes++
                        for yi in [Math.max(0, y-1)..Math.min(y+1, height)]
                            for xi in [Math.max(0, x-1)..Math.min(x+1, width)]
                                input[yi][xi] += 1
                        input[y][x] = ''

        input = chain input,
            Arr.map Arr.map (value)->
                if typeof(value) == 'string'
                    return 0
                return value
        return input

    for i in [1..100]
        input = step input

    part1 = flashes
    part2 = 100

    synchronized = Arr.all Arr.all (x)-> x == 0
    while not synchronized input
        input = step input
        part2++

    return {
        part1
        part2
    }