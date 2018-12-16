length = 323081
vector = [3, 2, 3, 0, 8, 1].reverse()

data = [3, 7]

x = 0
y = 1

answer = 0

part1 = true
part2 = true

# Part 2
check = (a1, a2)->
    if not part2
        return
    # Part 2
    for value, index in a2
        if a1[a1.length - 1 - index] != value
            return false
    part2 = false
    console.log a1.length - a2.length

while part1 or part2
    d = data[x] + data[y]
    if d >= 10
        data.push Math.floor d / 10
        check data, vector
    data.push d % 10
    check data, vector

    x = (x + data[x] + 1) % data.length
    y = (y + data[y] + 1) % data.length

    # Part 1
    if data.length >= (length + 10) and part1
        part1 = false
        console.log data[length...length + 10].join ""
