fs = require 'fs'

data = fs.readFileSync '2.txt', 'utf8'
.split '\n'
.filter (x)->x.trim().length > 0

histogram = (collection)->
    seen = new Map
    collection.forEach (element)->
        seen.set element, (seen.get(element) ? 0) + 1
    return seen

# Part 1
two = 0
three = 0
for id in data
    h = histogram histogram id.split ''
    if h.has 2
        two++
    if h.has 3
        three++
console.log two * three

# Part 2
for id1 in data
    for id2 in data
        errors = 0
        output = ''

        for x, i in id1
            if id1[i] != id2[i]
                errors++
            else
                output += id1[i]

        if errors == 1
            console.log output
