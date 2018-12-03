#input = 'vzbxkghb'
input = 'cqjxjnds'

code = []
for i in [input.length - 1..0]
    code.push input.charCodeAt(i) - 97

len = input.length

I = 'i'.charCodeAt(0) - 97
O = 'o'.charCodeAt(0) - 97
L = 'l'.charCodeAt(0) - 97

while true
    # Increment
    for i in [0..len]
        code[i]++
        if code[i] >= 26
            code[i] = 0
        else
            break

    # Requirement one
    success = false
    for i in [0..len - 3]
        if code[i] == (code[i + 1] + 1) == (code[i + 2] + 2)
            success = true
            break
    if not success
        continue

    # Requirement two
    fail = false
    for i in code
        if i == I or i == L or i == O
            fail = true
            break
    if fail
        continue

    # Requirement three
    a = -1
    success = false
    for i in [0..len - 1]
        if code[i] == code[i + 1]
            if a == -1
                a = code[i]
            else if code[i] != a
                success = true
                break
    if not success
        continue

    output = ''
    for i in [len - 1..0]
        output += String.fromCharCode (code[i] + 97)
    console.log output
