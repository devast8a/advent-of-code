{_, chain, compose, curry, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Op = require 'sweet-coffee/op'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'
Math = require 'sweet-coffee/math'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

# Read and format input
bags = chain '7.txt',
    Fs.readFile
    Str.trim
    
    Str.split '\n'
    Arr.reject Str.contains 'no other bags'

    Arr.flatMap compose [
        Str.replace /\sbags?/g, ''
        Str.split ' contain '
        ([first, contents])->
            chain contents,
                Str.split ','
                Regex.execAll /(\d+) ([\w\s]+)/g
                Arr.map ([_, count, second])-> {from: first, to: second, state: count}
    ]
    DirectedGraph.create.fromEdges

gold = bags.get 'shiny gold'

# Part 1
colors = Set.create()
getColors = (bag)->
    colors.add bag.key
    bag.inEdges.forEach (edge)->
        getColors edge.from
    return colors.size
console.log getColors(gold) - 1

# Part 2
countBags = (bag)->
    count = 1
    bag.outEdges.forEach (edge)->
        count += edge.state * countBags(edge.to)
    return count
console.log countBags(gold) - 1


# Alternative part 1
chain bags,
    DirectedGraph.depthFirstPath ['shiny gold'], Set.create(), (node, path, state)->
        state.add node.key
        return Array.from(node.inEdges).map (edge)-> {node: edge.from, state: state}
    get 'state.size'
    Op.sub 1
    console.log