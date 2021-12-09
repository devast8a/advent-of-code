{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

aoc
.setup
    date: '2021/9'
    tests: [
        string: """
            2199943210
            3987894921
            9856789892
            8767896789
            9899965678
        """
        part1: 15
        part2: 1134
    ]
.solve (input)->
    graph = chain input,
        Str.trim
        Str.split '\n'
        Arr.flatMap (row, y)->
            chain row,
                Str.split ''
                Arr.map Num.parseDec
                Arr.map (value, x)->
                    {key: Vec2d.create(x, y), data: value}
        DirectedGraph.create.fromNodes

    directions = [
        new Vec2d  1,  0
        new Vec2d -1,  0
        new Vec2d  0,  1
        new Vec2d  0, -1
    ]
    chain graph,
        DirectedGraph.nodes
        Arr.map ({key, data})->
            for direction in directions
                other = graph.getNode Vec2d.add key, direction
                if other? and other.data > data and other.data != 9 and data != 9
                    graph.addEdge [key, other.key]

    low_points = chain graph,
        DirectedGraph.nodes
        Arr.filter (node)-> node.inEdges.size == 0 and node.data != 9

    part1 = chain low_points,
        Arr.sumBy ({data})-> data + 1

    part2 = chain low_points,
        Arr.map DirectedGraph.depthFirst _, graph
        Arr.map get 'length'
        Arr.sortD
        Arr.take 3
        Arr.foldLR1 Op.mul

    {
        part1
        part2
    }