{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque, Set} = require 'sweet-coffee/all'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

aoc
.setup
    date: '2021/14'
    tests: [
        string: """
            NNCB

            CH -> B
            HH -> N
            CB -> H
            NH -> C
            HB -> C
            HC -> B
            HN -> C
            NN -> C
            BH -> H
            NC -> B
            NB -> B
            BN -> B
            BB -> N
            BC -> B
            CC -> N
            CN -> C
        """
        part1: 1588
    ]
.solve (input)->
    [pattern, rules] = chain input,
        Str.trim
        Str.split '\n\n'
        Arr.map Str.split '\n'

    pattern = pattern[0]
    state = chain pattern,
        (p) -> [p, p[1..]]
        Arr.mapN (a,b)->a+b
        Arr.histogram

    rules = chain rules,
        Arr.map Str.split ' -> '
        Map.create

    evolve = compose [
        Map.keyvalues
        Arr.flatMap ({key, value})->
            r = rules.get key
            return [[key[0] + r, value], [r + key[1], value]]
        Arr.groupBy get 0
        Map.values.map Arr.sumBy get 1
    ]

    for i in [1..40]
        state = evolve state

    state = chain state,
        Map.keyvalues
        Arr.flatMap ({key, value}) -> [[key[0], value]]
        Arr.groupBy get 0
        Map.values.map Arr.sumBy get 1

    p = pattern[pattern.length - 1]
    state.set p, 1 + state.get p

    chain state,
        Map.values
        (x)-> Arr.max(x) - Arr.min(x)
        console.log

    #chain pattern,
    #    Arr.histogram
    #    Map.values
    #    (values)-> Arr.max(values) - Arr.min(values)
    #    console.log

    return {}