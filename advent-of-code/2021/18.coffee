{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque, Set} = require 'sweet-coffee/all'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

aoc
.setup
    date: '2021/18'
    tests: [
        string: """
            [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
            [[[5,[2,8]],4],[5,[[9,9],0]]]
            [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
            [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
            [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
            [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
            [[[[5,4],[7,7]],8],[[8,3],8]]
            [[9,3],[[9,9],[6,[4,9]]]]
            [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
            [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
        """
        part1: 4140
        part2: 3993
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map eval

    LEFT  = 0
    RIGHT = 1
    CONTINUE = 2
    RETURN = 3
    EXPLODE = 4

    split = (number)->
        return [Math.floor(number / 2), Math.ceil(number / 2)]

    add = (field, node, replace)->
        if not (node instanceof Array) then return node + replace
        node = node.slice()
        node[field] = add field, node[field], replace
        return node

    explode = (node, depth = 1)->
        [left, right] = node

        if depth > 4 and not (left instanceof Array) and not (right instanceof Array)
            return [EXPLODE, left, right]

        if left instanceof Array
            [action, left, other] = explode left, depth + 1

            switch action
                when EXPLODE  then return [LEFT, [0, add(LEFT, right, other)], left]
                when LEFT     then return [LEFT, [left, right], other]
                when RIGHT    then return [RETURN, [left, add(LEFT, right, other)]]
                when RETURN   then return [RETURN, [left, right]]

        if right instanceof Array
            [action, right, other] = explode right, depth + 1

            switch action
                when EXPLODE  then return [RIGHT, [add(RIGHT, left, right), 0], other]
                when RIGHT    then return [RIGHT, [left, right], other]
                when LEFT     then return [RETURN, [add(RIGHT, left, other), right]]
                when RETURN   then return [RETURN, [left, right]]

        return [CONTINUE, [left, right]]

    split = (node)->
        if node instanceof Array
            [left, right] = node
            [action, left]  = split left
            [action, right] = split right   if action == CONTINUE
            return [action, [left, right]]
        if node >= 10
            return [RETURN, [Math.floor(node / 2) , Math.ceil(node / 2)]]
        return [CONTINUE, node]

    full = (node)->
        action = RETURN
        while action != CONTINUE
            [action, node] = explode node
            [action, node] = split node   if action == CONTINUE
        return node

    magnitude = (node)->
        if node instanceof Array
            return magnitude(node[0]) * 3 + magnitude(node[1]) * 2
        return node

    current = input[0]
    for next in input[1..]
        current = full [current, next]

    max = 0
    for x in input
        for y in input
            max = Math.max max, magnitude full [x, y]

    return {
        part1: magnitude current
        part2: max
    }