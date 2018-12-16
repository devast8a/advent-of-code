{_, chain, compose, curry, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Op = require 'sweet-coffee/op'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

ops = [
    (s, a, b, c)->s[c] = s[a] + s[b]
    (s, a, b, c)->s[c] = s[a] + b
    (s, a, b, c)->s[c] = s[a] * s[b]
    (s, a, b, c)->s[c] = s[a] * b
    (s, a, b, c)->s[c] = s[a] & s[b]
    (s, a, b, c)->s[c] = s[a] & b
    (s, a, b, c)->s[c] = s[a] | s[b]
    (s, a, b, c)->s[c] = s[a] | b
    (s, a, b, c)->s[c] = s[a]
    (s, a, b, c)->s[c] = a

    (s, a, b, c)->s[c] = if a > s[b] then 1 else 0
    (s, a, b, c)->s[c] = if s[a] > b then 1 else 0
    (s, a, b, c)->s[c] = if s[a] > s[b] then 1 else 0

    (s, a, b, c)->s[c] = if a == s[b] then 1 else 0
    (s, a, b, c)->s[c] = if s[a] == b then 1 else 0
    (s, a, b, c)->s[c] = if s[a] == s[b] then 1 else 0
]

validOperation = curry (op, sample)->
    state = sample.before.slice(0)
    instruction = sample.instruction
    op state, instruction[1], instruction[2], instruction[3]
    return Arr.eq state, sample.after

[samples, program] = chain '16.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n\n\n\n'

    Arr.map compose [
        Str.split '\n'
        Arr.map compose [
            Regex.extractAll /\d+/g
            Arr.map Num.parseDec
        ]
    ]

samples = chain samples,
    Arr.chunkSize 4
    Arr.map ([before, instruction, after])->
        {before, instruction, after}

# Part 1
chain samples,
    Arr.map (sample)->
        ops.filter validOperation _, sample
    Arr.filter (sample)->
        sample.length >= 3
    get 'length'
    console.log

# Part 2
candidates = chain samples,
    Arr.groupBy get 'instruction.0'
    Map.values.map (samples)->
        chain ops,
            Arr.filter (op)->
                Arr.all validOperation(op), samples
            Set.create
    Map.keyvalues

# Solve the mapping
mapping = new Array ops.length
while candidates.length > 0
    candidates = Arr.sortDBy get('1.size'), candidates
    [opcode, set] = candidates.pop()
    if set.size != 1 then throw new Error "Unable to solve"
    [op] = Array.from set

    for candidate in candidates
        candidate[1].delete op

    mapping[opcode] = op

# Execute the program
state = Arr.filled 5, 0
for [op, a, b, c] in program
    mapping[op] state, a, b, c
console.log state[0]
