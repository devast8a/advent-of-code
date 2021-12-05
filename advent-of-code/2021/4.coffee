{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/4'
    tests: [
        string: """
            7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

            22 13 17 11  0
            8  2 23  4 24
            21  9 14 16  7
            6 10  3 18  5
            1 12 20 15 19

            3 15  0  2 22
            9 18 13 17  5
            19  8  7 25 23
            20 11 10 24  4
            14 21 16 12  6

            14 21 17 24  4
            10 16 15  9 19
            18  8 23 26 20
            22 11 13  6  5
            2  0 12  3  7
        """
        part1: 4512
        part2: 1924
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'

    boards = chain input[2..],
        Arr.splitBy Str.isEmpty
        Arr.map compose [
            Arr.map compose [
                Str.trim
                Str.split /\s+/g
                Arr.map Num.parseDec
            ]
            (numbers) => {numbers: numbers, state: 0}
        ]

    drawn = chain input[0],
        Str.split ','
        Arr.map Num.parseDec

    part1 = 0
    part2 = 0

    for number in drawn
        for board in boards
            # You're already a winner mate
            continue if board.state != 0

            # Add number
            {numbers} = board
            for x, xi in numbers
                for y, yi in x
                    if y == number
                        numbers[xi][yi] = -0

            # Check for wins
            win = Arr.any Arr.all Op.eq -0
            if win(numbers) or win(Arr.transpose numbers)
                board.state = 1

                code = number * Arr.sum Arr.flatten numbers
                part1 = code if part1 == 0
                part2 = code

    return {
        part1
        part2
    }