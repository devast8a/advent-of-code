# Imports
{_, chain, compose, curry, get, Arr, Func, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
################################################################################

bags = chain '7.txt',
    Fs.readFileAsLines

    Arr.reject Str.contains 'no other bags'

    Arr.flatMap compose [
        Str.replace /\sbags?/g, ''
        Str.split ' contain '

        ([bag, contents])->
            chain contents,
                Regex.execAll /(\d+) ([\w\s]+)/g
                Arr.map ([count, containedBag])-> {from: bag, to: containedBag, data: Number(count)}
    ]
    DirectedGraph.create.fromEdges

# Part 1
#   How many bag colors can eventually contain at least one shiny gold bag?
chain bags,
    DirectedGraph.reverse
    DirectedGraph.depthFirst 'shiny gold'
    get 'length'
    Op.sub _, 1
    console.log

# Part 2
#   How many individual bags are required inside your single shiny gold bag?
chain bags,
    DirectedGraph.reduce (edges, node, graph)->
        chain edges,
            Arr.sumBy (edge)-> edge.data * edge.result
            Op.add 1
    Map.get 'shiny gold'
    Op.sub _, 1

    console.log