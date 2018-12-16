{chain, compose, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'

data = chain '15.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

map = new Array(data.length).fill(0).map((x)->new Array(data[0].length))
units = []

check = (x, y, fn)->
    if 0 <= x < map[0].length and 0 <= y < map.length and not map[y][x].blocked
        fn x, y

adj = (middle, fn)->
    check middle.x - 1, middle.y - 0, fn
    check middle.x - 0, middle.y - 1, fn
    check middle.x + 1, middle.y + 0, fn
    check middle.x + 0, middle.y + 1, fn

class Tile
    constructor: (@x, @y, @blocked)->
        @neighbors = []

    link: ->
        adj this, (x, y)=>
            @neighbors.push map[y][x]

class Unit
    constructor: (@team, @x, @y)->
        if @team == 1
            @attack = 34
        else
            @attack = 3
        @hp = 200

for row, y in data
    for tile, x in row
        blocked = false
        switch tile
            when '#' then blocked = true
            when 'G' then units.push new Unit 0, x, y
            when 'E' then units.push new Unit 1, x, y
        map[y][x] = new Tile x, y, blocked

# Link up the tiles
for row, y in map
    for tile, x in row
        tile.link()

pathFind = (start, self)->
    distances = new Array(data.length).fill(0).map((x)->new Array(data[0].length).fill(100000))

    openList = [
        map[start.y][start.x]
    ]

    distances[start.y][start.x] = 0

    while openList.length > 0
        tile = openList.pop()

        adj tile, (x, y)->
            n = distances[tile.y][tile.x] + 1
            if n < distances[y][x]
                for unit in units
                    if unit != self and unit.hp > 0 and unit.x == x and unit.y == y
                        return
                distances[y][x] = n
                openList.push map[y][x]

    return distances

attackTarget = (unit)->
    targets = []
    adj unit, (x, y)->
        for other in units
            if other.x == x and other.y == y and other.team != unit.team
                targets.push other

    if targets.length > 0
        target = chain targets,
            Arr.filter (x)->x.hp > 0
            (arr)->
                arr.sort (a, b)->
                    if a.hp < b.hp then return -1
                    if a.hp > b.hp then return 1
                    if a.y < b.y then return -1
                    if a.y > b.y then return 1
                    if a.x < b.x then return -1
                    if a.x > b.x then return 1
                    return 0
        if target.length > 0
            target[0].hp -= unit.attack
            return true
    return false

step = ->
    chain units,
        Arr.filter (x)->x.hp > 0
        Arr.sortABy ({x, y})-> y * 1000 + x
        Arr.forEach (unit)->
            if unit.hp <= 0
                return

            if attackTarget unit
                return

            if units.every (other)->other.team == unit.team
                console.log "DONE"

            targets = []
            chain units,
                Arr.filter (other)->
                    other.team != unit.team and other.hp > 0
                Arr.forEach (other)->
                    adj other, (x, y)->
                        for temp in units
                            if temp != unit and temp.hp > 0 and temp.x == x and temp.y == y
                                return
                        targets.push [other, map[y][x]]

            if targets.length == 0
                return

            p = []
            chain targets,
                Arr.forEach ([other, tile])->
                    distances = pathFind tile, unit

                    adj unit, (x, y)->
                        p.push {
                            next: distances[y][x]
                            distance: distances[unit.y][unit.x]
                            tile: tile
                            y: y
                            x: x
                            unit: other
                        }

            p.sort (a, b)->
                if a.distance < b.distance then return -1
                if a.distance > b.distance then return 1
                if a.tile.y < b.tile.y then return -1
                if a.tile.y > b.tile.y then return 1
                if a.tile.x < b.tile.x then return -1
                if a.tile.x > b.tile.x then return 1
                if a.next < b.next then return -1
                if a.next > b.next then return 1
                if a.y < b.y then return -1
                if a.y > b.y then return 1
                if a.x < b.x then return -1
                if a.x > b.x then return 1
                return 0

            best = p[0]

            if best.distance == 100000
                return

            if best.distance == 0
                attackTarget unit
                return

            unit.x = best.x
            unit.y = best.y

            if best.distance == 1
                attackTarget unit
                return

    if units.some (x)->x.team == 1 and x.hp <= 0
        console.log "FAILED"

    units = Arr.filter ((x)->x.hp > 0), units

display = ->
    # Output for debugging
    for row, y in map
        output = ''
        for tile, x in row
            drawn = '.'
            if tile.blocked
                drawn = '#'
                 
            for unit in units
                if unit.x == x and unit.y == y
                    if unit.team == 0
                        drawn = 'G'
                    else
                        drawn = 'E'
                    break
            output += drawn
        console.log output

    chain units,
        Arr.sortABy ({x, y})->y * 1000 + x
        Arr.forEach (x)->console.log x

count = 0
team = units[0].team
display()
while not units.every (x)->x.team == team
    count += 1
    console.log count
    step()
    #display()
    team = units[0].team
display()
#count -= 1

hp = chain units,
    Arr.sumBy get 'hp'

console.log count, count * hp
