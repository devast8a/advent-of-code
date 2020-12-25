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

v = 1
for i in [1..n]
    v = (v * 7) % n
    if v == a or v == b
        break

if v == a
    console.log "A", modexp b, i, n
else
    console.log "B", modexp a, i, n