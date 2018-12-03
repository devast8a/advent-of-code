fs = require 'fs'

data = fs.readFileSync '3.txt', 'utf8'
.split '\n'
.filter (x)->x.trim().length > 0

claims = new Array(1000 * 1000).fill(0)

# Part 1
for claim in data
    [id, at, coord, dim] = claim.split ' '
    [x, y] = coord[..-1].split ','
    [w, h] = dim.split 'x'

    X = parseInt x
    Y = parseInt y
    W = parseInt w
    H = parseInt h

    for x in [X...X + W]
        for y in [Y...Y + H]
            claims[(y * 1000) + x]++

total = 0
for c in claims
    if c > 1
        total++
console.log total

# Part 2
for claim in data
    [id, at, coord, dim] = claim.split ' '
    [x, y] = coord[..-1].split ','
    [w, h] = dim.split 'x'

    X = parseInt x
    Y = parseInt y
    W = parseInt w
    H = parseInt h

    BAD = false
    for x in [X...X + W]
        for y in [Y...Y + H]
            if claims[(y * 1000) + x] != 1
                BAD = true
    if not BAD
        console.log id

