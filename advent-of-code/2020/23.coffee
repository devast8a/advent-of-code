{LinkedList} = require 'sweet-coffee/container/linked-list'

# Read and format input
input = '389125467'
data = input.split('').map (x)-> parseInt x

simulate = ({list, map, steps, min, max})->
    current = list.head

    values = []
    nodes = []

    for i in [1..steps]
        values.length = 0
        nodes.length = 0

        for x in [1..3]
            next = current.next ? list.head

            values.push next.data
            nodes.push next
            list.remove next

        destination = current.data
        while true
            destination = destination - 1
            if destination < min
                destination = max
            if values.indexOf(destination) < 0
                break
        
        # Find the destination
        node = map.get destination
        list.insertNodeAfter node, nodes[2]
        list.insertNodeAfter node, nodes[1]
        list.insertNodeAfter node, nodes[0]

        current = current.next ? list.head
    return list


# Part 1
list = new LinkedList
map = new Map
for i in data
    map.set i, list.pushBack i

result = simulate
    list: list
    map: map
    steps: 100
    min: 1
    max: 9

#result = Deque.create result
#result.rotate -result.indexOf 1
#result.popLeft()
#console.log Array.from(result.entries()).join ''

# Part 2
list = new LinkedList
map = new Map
for i in data
    map.set i, list.pushBack i
for i in [10..1 * 1000 * 1000]
    map.set i, list.pushBack i

result = simulate
    list: list
    map: map
    steps: 10 * 1000 * 1000
    min: 1
    max: 1 * 1000 * 1000

node = map.get 1
a = node.next.data
b = node.next.next.data
console.log a, b, a * b