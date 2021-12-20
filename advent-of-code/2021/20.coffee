{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/20'
    tests: [
        {
            string: """
                ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

                #..#.
                #....
                ##..#
                ..#..
                ..###
            """
            part1: 35
            part2: 3351
        }
        {
            file: '20-kura.txt'
            part1: 5249
            part2: 15714
        }
    ]
.solve (input)->
    [rules, grid] = chain input,
        Str.trim
        Str.split '\n\n'

    grid = chain grid,
        Str.split '\n'
        Arr.map Arr.map (value)-> if value == '#' then 1 else 0

    rules = chain rules,
        Arr.map (value)-> if value == '#' then 1 else 0

    sample = (input, Y, X)->
        value = 0
        for y in [Y-1..Y+1] then for x in [X-1..X+1]
            if y < 0 or y >= input.length or x < 0 or x >= input.length
                value = (value << 1) | outside
            else
                value = (value << 1) | input[y][x]
        return value
    
    outside = 0
    step = (input)->
        output = new Array(input.length + 2).fill(0).map( -> new Array(input.length + 2).fill(0))
        for row, y in output then for _, x in row
            output[y][x] = rules[sample input, y - 1, x - 1]
        outside = rules[outside * 0x1FF]
        return output

    count = compose [Arr.flatten, Arr.count(1)]

    grid = step grid
    grid = step grid
    part1 = count grid

    for i in [0..47] then grid = step grid
    part2 = count grid

    return {
        part1
        part2
    }