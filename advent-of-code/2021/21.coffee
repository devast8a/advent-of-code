{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/21'
    tests: [
        string: """
            Player 1 starting position: 4
            Player 2 starting position: 8
        """
        part1: 739785
        part2: 444356092776315
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Regex.extractAll /\d+/g
        Arr.map Arr.map Num.parseDec
    
    die = 1
    score = [0, 0]
    position = [
        input[0][1] - 1
        input[1][1] - 1
    ]

    turn = 0
    while score.every (value)-> value < 1000
        value = die++
        value += die++
        value += die++
        position[turn] = (value + position[turn]) % 10
        score[turn] += position[turn] + 1
        turn = 1 - turn

    part1 = (die - 1) * Arr.min score

    table = new Array 21*10*21*10
    index = (xs,xp,ys,yp)-> xs*10*21*10 + xp*21*10 + ys*10 + yp
    dist = [[3,1], [4,3], [5,6], [6,7], [7,6], [8,3], [9,1]]

    for xs in [20..0] then for ys in [20..0] then for xp in [0..9] then for yp in [0..9]
        xw = 0
        yw = 0

        for [xr, xd] in dist
            # New game state
            n_xp = ((xr + xp) % 10)
            n_xs = xs + n_xp + 1

            if n_xs >= 21
                # Player 1 wins
                xw += 1 * xd
            else
                for [yr, yd] in dist
                    # New game state
                    n_yp = ((yr + yp) % 10)
                    n_ys = ys + n_yp + 1

                    if n_ys >= 21
                        # Player 2 wins
                        yw += 1 * xd * yd
                    else
                        # Neither player wins
                        state = table[index(n_xs,n_xp,n_ys,n_yp)]
                        xw += state[0] * xd * yd
                        yw += state[1] * xd * yd

        table[index(xs,xp,ys,yp)] = [xw, yw]

    part2 = table[index(0,input[0][1]-1,0,input[1][1]-1)][0]

    return {
        part1
        part2
    }