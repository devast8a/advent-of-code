{_, chain, compose, curry, get} = require 'sweet-coffee'

id = (x)->x

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

clip = (text)=>
    require('child_process').spawn('clip').stdin.end(text.toString())
    console.log(text)

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

part2 = chain data,
    Arr.filter (x)->
        return x.has('byr') and x.has('iyr') and x.has('eyr') and x.has('hgt') and x.has('hcl') and x.has('ecl') and x.has('pid')

    Arr.filter (x)->
        if not /^\d{4}$/.test(x.get('byr'))
            return false
        byr = parseInt x.get('byr')
        if not (1920 <= byr <= 2002)
            return false

        if not /^\d{4}$/.test(x.get('iyr'))
            return false
        iyr = parseInt x.get('iyr')
        if not (2010 <= iyr <= 2020)
            return false

        if not /^\d{4}$/.test(x.get('eyr'))
            return false
        eyr = parseInt x.get('eyr')
        if not (2020 <= eyr <= 2030)
            return false

        hgt = x.get('hgt')
        if hgt.endsWith('cm')
            hgt = parseInt hgt
            if not (150 <= hgt <= 193)
                return false
        else if hgt.endsWith('in')
            hgt = parseInt hgt
            if not (59 <= hgt <= 76)
                return false
        else
            return false


        if not /^#[a-f0-9]{6}$/.test(x.get('hcl'))
            return false

        if ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].indexOf(x.get('ecl')) == -1
            return false

        if not /^\d{9}$/.test(x.get('pid'))
            return false

        return true
    get 'length'

console.log part1, part2