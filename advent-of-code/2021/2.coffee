{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require './aoc'

aoc
.setup
    date: '2021/2'
    tests: [
        string: """
            forward 5
            down 5
            forward 8
            up 3
            down 8
            forward 2
        """
        part1: 150
        part2: 900
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Str.split ' '
        Arr.map ([x, y]) -> [x, Num.parseDec y]

    horizontal = 0
    depth = 0
    for [command, X] in input
        switch command
            when 'forward' then horizontal += X
            when 'down' then depth += X
            when 'up' then depth -= X
    part1 = horizontal * depth


    aim = 0
    horizontal = 0
    depth = 0
    for [command, X] in input
        switch command
            when 'forward'
                horizontal += X
                depth += aim * X
            when 'down' then aim += X
            when 'up' then aim -= X
    part2 = horizontal * depth

    return {
        part1
        part2
    }