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
ins = chain '14.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'

mem = Map.create()
zero = BigInt 0
one  = BigInt 0

for i in ins
    if i.startsWith 'mask ='
        mask     = i.split(' = ')[1]
        zero     = BigInt parseInt(mask.replace(/1|X/g, '1'), 2)
        one      = BigInt parseInt(mask.replace(/0|X/g, '0'), 2)
    else
        [loc, val] = chain i,
            Regex.execAll /\d+/g
            Arr.map get 0
            Arr.map Num.parseDec

        val = one | (zero & BigInt val)

        mem.set loc, val

sum = BigInt 0
for value from mem.values()
    sum += value
#console.log mem
console.log sum


mem = Map.create()
one  = BigInt 0
flt  = BigInt 0
fltm = BigInt 0
count = 0

for i in ins
    if i.startsWith 'mask ='
        mask     = i.split(' = ')[1]
        one      = BigInt parseInt(mask.replace(/0|X/g, '0'), 2)

        flt = chain mask,
            Str.replace /0|1/g, '0'
            Str.split ''
            Arr.withIndexes
            Arr.filter ({value})-> value == 'X'
            Arr.map (value, index)-> {
                bit: 1 << index
                value: BigInt(1) << BigInt(35 - value.index)
            }

        fltm = chain mask,
            Str.replace /0|1/g, '0'
            Str.replace /X/g, '1'
            Num.parseBin
            (value)-> BigInt value

    else
        [loc, val] = chain i,
            Regex.execAll /\d+/g
            Arr.map get 0
            Arr.map Num.parseDec
            Arr.map (value)-> BigInt value

        for num in [0 ... 2**flt.length]
            mask = chain flt,
                Arr.filter ({bit})-> (bit & num) > 0
                Arr.reduceLR BigInt(0), (x, y)-> x | y.value

            l = (~fltm & loc) | mask | one
            mem.set l, val

sum = BigInt 0
for value from mem.values()
    sum += value
#console.log mem
console.log sum