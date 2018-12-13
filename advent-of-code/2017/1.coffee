{chain, pluck} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'

data = chain '1.txt',
    # Read input
    Fs.readFile
    Str.trim

sum = 0
for letter, index in data[..-1]
    if letter == data[(index + 1) % data.length]
        sum += parseInt letter
console.log sum


sum = 0
for letter, index in data[..-1]
    if letter == data[(index + data.length/2) % data.length]
        sum += parseInt letter
console.log sum
