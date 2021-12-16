{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
{Set, HeapSet, ValueSemantics: {VsMap, compare}} = require 'sweet-ts'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

class Vol2d
    constructor: (a, b)->
        @lower = new Vec2d Math.min(a.x, b.x), Math.min(a.y, b.y)
        @upper = new Vec2d Math.max(a.x, b.x), Math.max(a.y, b.y)

    contains: (point)->
        @lower.x <= point.x and
        point.x <= @upper.x and
        @lower.y <= point.y and
        point.y <= @upper.y

Vol2d.create = (a, b)-> new Vol2d a, b

pathFind = ({start, end, cost, adjacent, estimate})->
    openSet = HeapSet.create (left, right)-> estimates.get(left) < estimates.get(right)

    distances = new VsMap
    estimates = new VsMap

    openSet.insert start
    distances.set start, 0
    estimates.set start, estimate start, end

    while openSet.size > 0
        current = openSet.remove()
        
        if compare current, end
            break

        currentDist = distances.get current

        for neighbor in adjacent current
            neighborDist = distances.get neighbor
            newDist = currentDist + cost current, neighbor

            if not neighborDist? or newDist < neighborDist
                distances.set neighbor, newDist
                estimates.set neighbor, newDist + estimate neighbor, end
                openSet.insert neighbor

    return distances

aoc
.setup
    date: '2021/15'
    tests: [
        string: """
            1163751742
            1381373672
            2136511328
            3694931569
            7463417111
            1319128137
            1359912421
            3125421639
            1293138521
            2311944581
        """
        part1: 40
        part1: 315
    ]
.solve (input)->
    input = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Str.split ''
        Arr.map Arr.map Num.parseDec

    solve = ->
        start = Vec2d.zero
        end = Vec2d.create input[0].length - 1, input.length - 1
        dimensions = Vol2d.create start, end

        distances = pathFind
            start: start
            end: end
            cost: (_, {x, y})-> input[y][x]
            adjacent: Vec2d.orthogonal dimensions
            estimate: Vec2d.distance.manhattan end
        return distances.get end

    part1 = solve()

    # Duplicate everything
    add = (n, value)-> (value + n - 1) % 9 + 1
    input = chain input,
        Arr.map (arr)->
            Arr.flatten [
                arr
                arr.map (value)-> add 1, value
                arr.map (value)-> add 2, value
                arr.map (value)-> add 3, value
                arr.map (value)-> add 4, value
            ]
        (arr)->
            Arr.flatten [
                arr
                arr.map (row)-> row.map (value)-> add 1, value
                arr.map (row)-> row.map (value)-> add 2, value
                arr.map (row)-> row.map (value)-> add 3, value
                arr.map (row)-> row.map (value)-> add 4, value
            ]

    start = Date.now()
    part2 = solve()
    end = Date.now()
    console.log end - start

    return {
        part1: part1
        part2: part2
    }