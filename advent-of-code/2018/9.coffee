{chain, pluck} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'

players = 459
marbles = 71320

solve = (marbles)->
    players = Arr.filled players, 0
    circle = Deque.create()
    player = 0
    circle.push 0

    for i in [1..marbles]
        if i % 23 == 0
            circle.rotate -7
            players[player] += i
            players[player] += circle.popLeft()
            circle.rotate 1
        else
            circle.rotate 1
            circle.pushLeft i

        player = (player + 1) % players.length

    chain players,
        Arr.max
        console.log

# Part 1
solve marbles

# Part 2
solve marbles * 100
