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
[start, routes] = chain '13.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'

start = Num.parseDec start

routes = chain routes,
    Str.split ','
    Arr.map (value)-> if value == 'x' then null else Num.parseDec(value)

times = [start .. start + Arr.max(routes) * 2]

chain times,
    Arr.map (time)-> [time, routes.filter (route)-> time % route == 0]
    Arr.findBy ([_, routes])-> routes.length > 0
    ([time, routes])-> (time - start) * routes[0]
    console.log

routes = chain routes,
    Arr.withIndexes
    Arr.filter get 'value'
    Arr.map ({value, index})-> "#{value}x + #{index}"
    console.log

console.log count