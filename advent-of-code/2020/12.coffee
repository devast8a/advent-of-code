{_, chain, compose, curry, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Op = require 'sweet-coffee/op'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'
Math = require 'sweet-coffee/math'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

# Read and format input
commands = chain '12.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'

x = 0
y = 0
r = 0
for command in commands
    num = Num.parseDec command[1..]

    switch command[0]
        when 'N' then y += num
        when 'S' then y -= num
        when 'E' then x -= num
        when 'W' then x += num
        when 'L' then r = (360 + r - num) % 360
        when 'R' then r = (360 + r + num) % 360
        when 'F'
            switch r
                when 0   then x -= num # East
                when 90  then y -= num # South
                when 180 then x += num # West
                when 270 then y += num # North
                else
                    console.log r
console.log Math.abs(x) + Math.abs(y)


x = 0
wx = -10
y = 0
wy = 1
for command in commands
    num = Num.parseDec command[1..]

    switch command[0]
        when 'N' then wy += num
        when 'S' then wy -= num
        when 'E' then wx -= num
        when 'W' then wx += num

        when 'L','R'
            if command[0] == 'L' then num = 360 - num
            switch num
                when 90  then [wx, wy] = [-wy, wx]
                when 180 then [wx, wy] = [-wx, -wy]
                when 270 then [wx, wy] = [wy, -wx]
                else console.log num

        when 'F'
            x += wx * num
            y += wy * num
console.log Math.abs(x) + Math.abs(y)