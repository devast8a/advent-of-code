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

genChecksum = (letters)->
    chain letters,
        Str.replace /-/g, ''
        Arr.groupBy (x)->x
        Map.values.map get 'length'
        Map.keyvalues
        (values)->
            values.sort (a, b)->
                if a.value < b.value then return 1
                if a.value > b.value then return -1
                if a.key < b.key then return -1
                if a.key > b.key then return 1
                return 0
        Arr.take 5
        Arr.map get 'key'
        Str.join ''

# Read and format input
data = chain '4.txt',
    Fs.readFile
    Str.trim

    Str.split '\n'
    Arr.map compose [
        Regex.exec /([\w-]+)-(\d+)\[(\w+)\]/
        ([_, letters, id, checksum])-> {letters, id, checksum}
    ]
    Arr.filter ({letters, checksum})-> genChecksum(letters) == checksum
    Arr.map compose [
        get 'id'
        Num.parseDec
    ]
    Arr.sum
    console.log