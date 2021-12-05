{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

unzip = curry (f, args)->
    f ...args

aoc
.setup
    date: '2021/1'
    tests: [
        {
            string: """
                199
                200
                208
                210
                200
                207
                240
                269
                260
                263
            """
            part1: 7
            part2: 5
        }
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Num.parseDec

    part1 = chain [input[1..], input],
        Arr.zipN
        Arr.countBy unzip Op.gt

    part2 = chain [input[3..], input],
        Arr.zipN
        Arr.countBy unzip Op.gt

    return {
        part1
        part2
    }