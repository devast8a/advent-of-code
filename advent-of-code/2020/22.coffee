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
[p1, p2] = chain '22.txt',
    Fs.readFile
    Str.trim
    Str.split '\n\n'
    Arr.map compose [
        Str.split '\n'
        Arr.skip 1
        Arr.map Num.parseDec
    ]

play = (p1, p2, recursive)->
    seen = Set.create()
    while p1.length > 0 and p2.length > 0
        gamecode = "#{p1}-#{p2}"
        if seen.has gamecode
            return [[], []]
        seen.add gamecode

        a = p1.shift()
        b = p2.shift()

        if p1.length >= a and p2.length >= b and recursive
            subgame = play p1[0...a], p2[0...b], true
            p1Win = subgame[1].length == 0
        else
            p1Win = a >= b

        if p1Win
            p1.push a
            p1.push b
        else
            p2.push b
            p2.push a

    return [p1, p2]

chain play(p1.slice(0), p2.slice(0), false),
    Arr.maxBy get 'length'
    (x)-> x.reverse()
    Arr.sumBy (x, i)-> x * (i + 1)
    console.log

chain play(p1, p2, true),
    Arr.maxBy get 'length'
    (x)-> x.reverse()
    Arr.sumBy (x, i)-> x * (i + 1)
    console.log
