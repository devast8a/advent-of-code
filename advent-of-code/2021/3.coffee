{_, chain, compose, curry, get, Arr, Func, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/3'
    tests: [
        string: """
            00100
            11110
            10110
            10111
            10101
            01111
            00111
            11100
            10000
            11001
            00010
            01010
        """,
        part1: 198
        part2: 230
        parameters: { bits: 5 }
    ]
    parameters: { bits: 12 }
.solve (input, {bits})->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Num.parseBin

    negate = (value)-> ~value & ((1 << bits) - 1)
    count  = curry (bit, input)-> Arr.countBy(_, input) (value)-> (value & (1 << bit)) > 0
    common = curry (bit, input)-> count(bit, input) >= (input.length / 2)
    select = curry (bit, select, value)-> ((value & (1 << bit)) > 0) == select

    # Part 1
    gamma_rate = 0
    for bit in [0..bits-1]
        if common bit, input
            gamma_rate |= (1 << bit)

    # Part 2
    filter = (input, f)->
        for bit in [bits-1..0]
            c = f common bit, input
            input = Arr.filter select(bit, c), input
            break if input.length <= 1
        return input[0]

    o2 = filter input, Func.id
    co2 = filter input, Op.notL

    return {
        part1: gamma_rate * negate gamma_rate
        part2: o2 * co2
    }