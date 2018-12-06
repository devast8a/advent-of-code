{chain} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'

fs = require 'fs'

data = fs.readFileSync '5.txt', 'utf8'
data = data.trim()

a = 'abcdefghijklmnopqrstuvwxyz'
b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
r = []

for i in [0..25]
    r.push a[i] + b[i]
    r.push b[i] + a[i]

r = new RegExp "(#{r.join '|'})", 'g'
console.log r

react = (data)->
    next = data.replace r, ''
    while next != data
        data = next
        next = data.replace r, ''
    return data

console.log react(data).length

chain a,
    Arr.map (value)->
        d = data.replace new RegExp(value, 'g'), ''
        d = d.replace new RegExp(value.toUpperCase(), 'g'), ''
        return react(d).length
    Arr.min
    console.log
