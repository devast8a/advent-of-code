a = 11349501
b = 5107328
n = 20201227

modexp = (b, e, n)->
    b = b % n
    r = 1

    while e > 0
        if (e & 1) == 1
            r = (r * b) % n
        e = e >> 1
        b = (b * b) % n

    return r

console.time "solution"
v = 1

n1 = n * 1
n2 = n * 2
n3 = n * 3
n4 = n * 4
n5 = n * 5
n6 = n * 6

for i in [1..n]
    v = v * 7
    v %= n
    if v == a or v == b
        break

if v == a
    console.log "A", modexp b, i, n
else
    console.log "B", modexp a, i, n
console.timeEnd "solution"
