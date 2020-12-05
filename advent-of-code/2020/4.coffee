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
data = chain '4.txt',
    Fs.readFile
    Str.trim

    Str.split '\n\n'
    Arr.map compose [
        Str.split '\n'
        Arr.flatMap Str.split ' '
        Arr.map Str.split ':'
        Map.create
    ]

part1 = chain data,
    Arr.filter (x)->
        return x.has('byr') and x.has('iyr') and x.has('eyr') and x.has('hgt') and x.has('hcl') and x.has('ecl') and x.has('pid')
    get 'length'

Range    = curry (start, end, value)-> start <= parseInt(value) <= end
All      = curry (fns, value)-> Arr.all(((fn)->fn(value)), fns)
Validate = curry (field, fns)-> compose [ Map.get(field), All(fns) ]

part2 = chain data,
    Arr.filter All [
        Validate 'byr', [ Regex.matchAll(/\d{4}/), Range(1920, 2002) ]
        Validate 'iyr', [ Regex.matchAll(/\d{4}/), Range(2010, 2020) ]
        Validate 'eyr', [ Regex.matchAll(/\d{4}/), Range(2020, 2030) ]
        Validate 'hcl', [ Regex.matchAll(/#[a-f0-9]{6}/) ]
        Validate 'ecl', [ Arr.contains(_, ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']) ]
        Validate 'pid', [ Regex.matchAll(/\d{9}/) ]
        Validate 'hgt', [ Regex.matchAll(/\d+(cm|in)/), (hgt)->
            (hgt.endsWith('cm') and Range(150, 193, hgt)) or
            (hgt.endsWith('in') and Range(59, 76, hgt))
        ]
    ]
    get 'length'

console.log part1, part2