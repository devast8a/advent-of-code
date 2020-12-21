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
entries = chain '21.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'
    Arr.map compose [
        Str.replace ')', ''
        Str.split ' (contains '
        ([alien, english])->
            return {
                alien: alien.split ' '
                english: english.split ', '
            }
    ]

alien = chain entries,
    Arr.flatMap get 'alien'
    Arr.unique

mapping = chain entries,
    Arr.flatMap get 'english'
    Arr.unique
    Arr.map (word)-> [word, Set.create alien]
    Map.create

for entry in entries
    for word in entry.english
        set = mapping.get word
        set = Set.intersection set, Set.create entry.alien
        mapping.set word, set

narrowed = chain mapping.values(),
    Arr.from
    Arr.flatMap Arr.from

chain alien,
    Arr.reject Arr.contains _, narrowed
    Arr.sumBy (word)->
        entries.filter((entry)-> Arr.contains word, entry.alien).length
    console.log

results = []
mapping = Arr.from mapping.entries()
while mapping.length > 0
    mapping.sort (a, b)-> b[1].size - a[1].size
    entry = mapping.pop()
    alien = Array.from(entry[1])[0]
    results.push [entry[0], alien]

    for entry in mapping
        entry[1].delete alien

chain results,
    Arr.sortABy get 0
    Arr.map get '1'
    Str.join ','
    console.log