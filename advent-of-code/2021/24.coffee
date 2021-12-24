{_, chain, compose, curry, get, Arr, Fs, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
{Vec2, Vec3, Box3} = require 'sweet-coffee/vec'
aoc = require '../aoc'

aoc
.setup
    date: '2021/24'
    tests: []
.solve (input)->
    program = chain input,
        Str.trim
        Str.split '\n'

    magic = chain program,
        Arr.filter (_, i)-> i%18 in [4,5,15]
        Arr.map compose [
            Str.split ' '
            get 2
            Num.parseDec
        ]
        Arr.chunkSize 3

    max = []
    min = []
    stack = []
    for [a,b,c], i2 in magic
        if a == 1
            stack.push [i2,c]
        else
            [i1,c] = stack.pop()
            r = b+c

            if r < 0
                max[i1] = 9
                max[i2] = 9+r
                min[i1] = 1-r
                min[i2] = 1
            else
                max[i1] = 9-r
                max[i2] = 9
                min[i1] = 1
                min[i2] = 1+r

    console.log max.join ''
    console.log min.join ''