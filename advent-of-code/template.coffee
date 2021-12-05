{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: 'xxxx/x'
    tests: []
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Num.parseDec
        Arr.map compose [
            Regex.exec /foobar/
            (a, b, c)-> {a, b, c}
        ]

    part1 = chain input,
        (a)-> a

    part2 = chain input,
        (a)-> a

    return {
        part1
        part2
    }