START = new Date().getTime()

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

data = chain '12.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

convert = (result)->
    if result == '.'
        return 0
    else
        return 1

convertRule = (rule)->
    value = 0
    for i in [0...5]
        value += convert(rule[i]) * 2**i
    return value

rules = Arr.filled 32, 0
chain data,
    Arr.skip 2
    Arr.map Regex.exec /([\.#]+) => ([\.#])/
    Arr.map ([_, rule, result])->
        rules[convertRule(rule)] = convert result

prefix = 20
state = chain data[0],
    Regex.extract /[\.#]+/
    Arr.map convert
    Arr.concatFront Arr.filled prefix, 0
    Arr.concatBack Arr.filled 200, 0

mutate = (value)->
    value
    for {rule, result} in rules
        if rule == value
            return result
    return 0

# Part 1
length = state.length - 4
state1 = state.map (x)->x
state2 = state.map (x)->x
for step in [0...20]
    for v in [0...length]
        value = 0
        for i in [0...5]
            value += state1[v+i] * 2**i
        state2[v + 2] = rules[value]

    temp = state2
    state2 = state1
    state1 = temp

chain state1,
    Arr.sumBy (value, index)->
        value * (index - prefix)
    console.log

# Part 2
cycles = 50000000000

console.log "Attempting to find a steady state"
length = state.length - 4
state1 = state.map (x)->x
state2 = state.map (x)->x
previous = []
for step in [0...cycles]
    for v in [0...length]
        value = 0
        for i in [0...5]
            value += state1[v+i] * 2**i
        state2[v + 2] = rules[value]

    temp = state2
    state2 = state1
    state1 = temp

    # Have we reached a steady state?
    previous.push Arr.sum state1
    if previous.length > 5
        previous.shift()

        if previous.every (x)-> x == previous[0]
            # We've reached a steady state
            console.log "Found steady state at cycle #{step}"
            break

for i in [state1.length-1..0]
    if state1[i] == 1
        offset = i
        break
console.log "Right most offset #{offset}"

offset += 1
console.log "Simulating until offset #{offset} is reached"

for step in [step+1...cycles]
    for v in [0...length]
        value = 0
        for i in [0...5]
            value += state1[v+i] * 2**i
        state2[v + 2] = rules[value]

    temp = state2
    state2 = state1
    state1 = temp

    if state1[offset] == 1
        console.log "Reached #{offset} on step #{step}"
        break
s1 = step

offset += 1
console.log "Simulating until offset #{offset} is reached"

for step in [step+1...cycles]
    for v in [0...length]
        value = 0
        for i in [0...5]
            value += state1[v+i] * 2**i
        state2[v + 2] = rules[value]

    temp = state2
    state2 = state1
    state1 = temp

    if state1[offset] == 1
        console.log "Reached #{offset} on step #{step}"
        break
s2 = step

offset += 1
console.log "Simulating until offset #{offset} is reached"

for step in [step+1...cycles]
    for v in [0...length]
        value = 0
        for i in [0...5]
            value += state1[v+i] * 2**i
        state2[v + 2] = rules[value]

    temp = state2
    state2 = state1
    state1 = temp

    if state1[offset] == 1
        console.log "Reached #{offset} on step #{step}"
        break
s3 = step

if (s3 - s2) != (s2 - s1)
    throw new Error ":( Can't solve this"
else
    console.log "We all good, everything is linear"

# To advance one element we move this much
factor = (s3 - s2)
if factor != 1 then throw new Error "TODO"

# How far it will move... so just like pretend to move it
distance = (cycles-s3)/factor

console.log "Warp it #{distance} blocks"

# Go ahead and sum it with the new distance
chain state1,
    Arr.sumBy (value, index)->
        value * (index - prefix + distance - 1)
    console.log

END = new Date().getTime()
console.log END - START
