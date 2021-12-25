{_, chain, compose, curry, get, Arr, Fs, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
{Vec2, Vec3, Box3} = require 'sweet-coffee/vec'
aoc = require '../aoc'

aoc
.setup
    date: '2021/25'
    tests: [
        {
            string: """
                v...>>.vv>
                .vv>>.vv..
                >>.>v>...v
                >>v>>.>.v.
                v>v.vv.v..
                >.>>..v...
                .vv..>.>v.
                v.v..>>v.v
                ....v..v.>
            """
        }
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Str.split ''

    moved = true
    turn = 0
    while moved
        turn++
        moved = false
        output = new Array(input.length).fill(0).map(() -> new Array(input[0].length).fill('.'))

        for row, y in input then for value, x in row
            if value == '>'
                if x + 1 >= input[0].length
                    if input[y][0] == '.'
                        moved = true
                        output[y][0] = '>'
                    else
                        output[y][x] = input[y][x]
                else if input[y][x + 1] == '.'
                    moved = true
                    output[y][x + 1] = '>'
                else
                    output[y][x] = input[y][x]
            else if value == 'v'
                output[y][x] = input[y][x]

        input = output
        output = new Array(input.length).fill(0).map(() -> new Array(input[0].length).fill('.'))

        for row, y in input then for value, x in row
            if value == 'v'
                if y + 1 >= input.length
                    if input[0][x] == '.'
                        moved = true
                        output[0][x] = 'v'
                    else
                        output[y][x] = input[y][x]
                else if input[y + 1][x] == '.'
                    moved = true
                    output[y + 1][x] = 'v'
                else
                    output[y][x] = input[y][x]
            else if value == '>'
                output[y][x] = input[y][x]

        input = output

    return {
        part1: turn
    }