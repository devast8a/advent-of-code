fs = require 'fs'

nums = fs.readFileSync '1.txt', 'utf8'
.split '\n'
.filter (x)->x.trim().length > 0
.map (x)->parseInt x, 10

# Part 1
console.log nums.reduce (x, y)->x + y

# Part 2
seen = new Set
total = 0
while true
    for num in nums
        total += num
        if seen.has total
            console.log total
            return
        seen.add total
