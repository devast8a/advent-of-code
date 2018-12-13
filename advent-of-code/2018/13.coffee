{chain, compose, pluck} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'

state = []
carts = []

UP = 0
RIGHT = 1
DOWN = 2
LEFT = 3

turns = [3, 0, 1]

class Cart
    constructor: (@x, @y, @direction)->
        @turn = 0
        @id = carts.length
        @alive = true
        
    move: ->
        switch @direction
            when UP    then @y -= 1
            when DOWN  then @y += 1
            when LEFT  then @x -= 1
            when RIGHT then @x += 1

        switch state[@y][@x]
            when '/'  then @direction = [RIGHT, UP, LEFT, DOWN][@direction]
            when '\\' then @direction = [LEFT, DOWN, RIGHT, UP][@direction]
            when '+'
                @direction = (@direction + turns[@turn]) % 4
                @turn = (@turn + 1) % turns.length

data = chain '13.txt',
    Fs.readFile
    Str.split '\n'
    Arr.map (line, y)->
        s = []
        for v, x in line
            if v == 'v'
                carts.push new Cart x, y, DOWN

            if v == '>'
                carts.push new Cart x, y, RIGHT

            if v == '<'
                carts.push new Cart x, y, LEFT

            if v == '^'
                carts.push new Cart x, y, UP

            s.push v
        state.push s

findCollision = ->
    go = true
    while go
        carts = chain carts,
            Arr.sortABy ({x, y})->
                y*100000 + x

        for cart in carts
            if cart.alive
                cart.move()
                
                for other in carts
                    if other != cart and other.x == cart.x and other.y == cart.y and other.alive
                        console.log "CRASH", cart.x, cart.y
                        cart.alive = false
                        other.alive = false

        carts = chain carts,
            Arr.filter pluck 'alive'

        if carts.length == 1
            go = false
            console.log "LAST", carts[0].x, carts[0].y

findCollision()
