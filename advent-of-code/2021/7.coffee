{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/7'
    tests: [
        string: '16,1,2,0,4,2,7,1,2,14'
        part1: 37
        part2: 168
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split ','
        Arr.map Num.parseDec

    solve = (diff) ->
        chain [Arr.min(input)...Arr.max(input)],
            Arr.map (target) -> Arr.sumBy diff(target), input
            Arr.min

    part1 = solve curry (x, y) -> Math.abs x - y
    part2 = solve curry (x, y) -> Math.abs(x - y) * (Math.abs(x - y) + 1) / 2

    return {
        part1
        part2
    }