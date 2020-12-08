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
code = chain '8.txt',
    Fs.readFile
    Str.trim
    
    Str.split '\n'
    Arr.map Str.split ' '
    Arr.map ([x, y])-> [x, parseInt y]

run = (code)->
    ip = 0
    acc = 0
    seen = code.map -> false

    while ip < code.length
        return [false, acc] if seen[ip]
        seen[ip] = true

        switch code[ip][0]
            when 'nop' then acc += 0
            when 'acc' then acc += code[ip][1]
            when 'jmp' then ip += code[ip][1] - 1
        ip += 1
    return [true, acc]

# Part 1
console.log run(code)[1]

# Part 2
for i in [0..code.length]
    copy = code.slice 0
    copy[i] = 'nop'
    [terminated, acc] = run copy

    if terminated
        console.log acc
        break