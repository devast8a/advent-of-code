# Imports
{_, chain, compose, curry, get, Arr, Func, Fs, Map, Num, Op, Regex, Str, Math, DirectedGraph, Deque, Set} = require 'sweet-coffee/all'
################################################################################

################################################################################
# Commented after

# The file contains content like
#   light red bags contain 1 bright white bag, 2 muted yellow bags.
#   dark orange bags contain 3 bright white bags, 4 muted yellow bags.
#   bright white bags contain 1 shiny gold bag.
#   muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
#   shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
#   dark olive bags contain 3 faded blue bags, 4 dotted black bags.
#   vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
#   faded blue bags contain no other bags.
#   dotted black bags contain no other bags.
#
# The goal is to turn this into a list of edges
#   [
#     {from: "light red", to: "bright white", data: 1},
#     {from: "light red", to: "muted yellow", data: 2},
#     {from: "dark orange", "to": "bright white", data: 3},
#     ...
#   ]
#
bags = chain '7.txt',
    Fs.readFileAsLines

    # The input contains explicit statements about which bags are leaf nodes.
    # We don't need this data so reject it.
    Arr.reject Str.contains 'no other bags'

    # For each line
    Arr.flatMap compose [
        # Remove the bag/bags from the line so we now just have
        #   light red contain 1 bright white, 2 muted yellow.
        Str.replace /\sbags?/g, ''

        # Split the line into the bag and its contents
        #   ['light red', '1 bright white, 2 muted yellow']
        Str.split ' contain '

        # Destructure line into bag and contents
        ([bag, contents])->
            chain contents,
                # For each bag in contents extract the number and name of the bag
                #   [['1', 'bright white'], ['2', 'muted yellow']]
                Regex.execAll /(\d+) ([\w\s]+)/g

                # Convert each bag into an edge
                #   {from: 'light red', to: 'bright white', data: 1}
                Arr.map ([count, containedBag])-> {from: bag, to: containedBag, data: Number(count)}
    ]

    DirectedGraph.create.fromEdges

# Part 1
#   How many bag colors can eventually contain at least one shiny gold bag?
chain bags,
    # The graph's forward edges link a bag with the bags it contains.
    #   Reverse it, so the forward edges link a bag with the bags that contain it.
    DirectedGraph.reverse

    # Starting from the 'shiny gold' bag, perform a depth first search of the graph.
    #   The result is an array of nodes that can be reached from the start node, deduplicated and in the order the node
    #   is first seen. This gives us all bags that contain a 'shiny gold' bag.
    DirectedGraph.depthFirst 'shiny gold'

    # We just want the number of bags
    get 'length'

    # The result includes the 'shiny gold' bag itself.
    Op.sub _, 1

    console.log

# Part 2
#   How many individual bags are required inside your single shiny gold bag?
chain bags,
    # DirectGraph.reduce will topologically sort the graph, then for each node in the graph call your provided function.
    #   edge.result is the result of calling the function on the parent node
    DirectedGraph.reduce (edges, node, graph)->
        chain edges,
            # edge.data is the number of bags that directly contain the current bag
            # edge.result is the number of bags that contain the parent bag
            Arr.sumBy (edge)-> edge.data * edge.result
            Op.add 1

    # return value of DirectedGraph.reduce is a map with the result of the function for each node
    # We just care about how many bags contain a shiny gold bag
    Map.get 'shiny gold'

    # The result includes the 'shiny gold' bag itself.
    Op.sub _, 1

    console.log
