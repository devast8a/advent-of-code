{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

aoc
.setup
    date: '2021/10'
    tests: [
        string: """
            [({(<(())[]>[[{[]{<()<>>
            [(()[<>])]({[<{<<[]>>(
            {([(<{}[<>[]}>{[]{[(<()>
            (((({<>}<{<{<>}{[]{[]{}
            [[<[([]))<([[{}[[()]]]
            [{[{({}]{}}([{[{{{}}([]
            {<[[]]>}<{[{[{[]{()[[[]
            [<(<(<(<{}))><([]([]()
            <{([([[(<>()){}]>(<<{{
            <{([{{}}[<[[[<>{}]]]>[]]
        """
        part1: 26397
        part2: 288957
    ]
.solve (input)->
    start = "([{<"
    end = ")]}>"

    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map (line)->
            stack = []
            for c in line
                if start.includes c
                    stack.push c
                else if c != end[start.indexOf(stack.pop())]
                    return [c]
            return stack

    part1 = chain input,
        Arr.sumBy (c)-> [0, 3, 57, 1197, 25137][end.indexOf(c) + 1]

    part2 = chain input,
        Arr.reject Str.contains _, end
        Arr.map compose [
            Arr.reverse
            Arr.map (x)-> start.indexOf(x) + 1
            Arr.foldLR 0, (score, value)-> score * 5 + value
        ]
        Math.median

    return {
        part1
        part2
    }