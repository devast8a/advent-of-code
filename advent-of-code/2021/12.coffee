{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque, Set} = require 'sweet-coffee/all'
aoc = require '../aoc'

aoc
.setup
    date: '2021/12'
    tests: [
        string: """
            start-A
            start-b
            A-c
            A-b
            b-d
            A-end
            b-end
        """
        part1: 10
        part2: 36
    ]
.solve (input)->
    graph = chain input,
        Str.trim
        Str.split '\n'
        Arr.map Str.split '-'
        Graph.fromUndirectedEdges

    visit = (graph, start, allow_double) ->
        double = null
        paths = []

        inner = (graph, key, path)->
            if key == 'start' and path.length != 0
                return

            if key == 'end'
                path.push key
                paths.push path.slice()
                path.pop()
                return

            if key.toLowerCase() == key
                if path.indexOf(key) != -1
                    if allow_double and double == null
                        double = key
                    else
                        return


            path.push key

            if key == 'end'
                paths.push path.slice()
                path.pop()
                return

            node = graph.getNode key

            for next from node.outEdges
                inner graph, next.to.key, path

            path.pop()

            if key == double
                double = null

        inner graph, start, []
        return paths

    part1 = visit(graph, 'start', false).length
    part2 = visit(graph, 'start', true).length

    return {
        part1: part1,
        part2: part2,
    }