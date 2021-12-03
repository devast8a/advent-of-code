{_, chain, compose, curry, get} = require 'sweet-coffee'

Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Num = require 'sweet-coffee/num'
Op = require 'sweet-coffee/op'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

# Containers
DirectedGraph = require 'sweet-coffee/container/directed-graph'
Deque = require 'sweet-coffee/container/deque'
Set = require 'sweet-coffee/container/set'

data = chain '11.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

    #CellularAutomata.create.fromDenseSymbols
    #    size: [10, 10]
    #    symbols: '.|#'
    #    rules: rules

    #    constrain: true
    #    neighborhood: 1

    #CellularAutomata.simulate 100000

class DenseSim
    constructor: (@rules, @size)->
        @generation = 0

        @size_ = @size.map (x)-> x + 2
        length = @size_.reduce ((a, b)-> a * b), 1

        @data = new Array(length).fill(0)
        @write = new Array(@size_[0] * 2).fill(0)
        @hash = 0

    clone: ->
        sim = new DenseSim @rules, @size
        sim.generation = @generation
        sim.hash = @hash
        sim.data = @data.slice 0
        return sim

    load: (data)->
        for row, y in data
            for tile, x in row
                @data[(y + 1) * @size_[0] + (x + 1)] = symbols.indexOf tile
        return

    dense_x_step: (writeOffset, y)->
        width = @size_[0] - 2
        for x in [1..width]
            # TODO: Optimize the calculation of counts
            counts = [0, 0, 0]
            tiles = []

            for yi in [y - 1 .. y + 1]
                for xi in [x - 1 .. x + 1]
                    tile = @data[yi * @size_[0] + xi]
                    @hash += tile
                    counts[tile] += 1

            tile = @data[y * @size_[0] + x]
            counts[tile] -= 1
            @write[writeOffset + x] = @rules[tile] counts
        return

    step: ->
        @generation += 1
        writeOffset = 0
        @hash = 0

        width = @size_[0]
        writeLength = width * 2

        for y in [1..1]
            @dense_x_step writeOffset, y
            writeOffset = (writeOffset + width) % writeLength

        for y in [2..width - 2]
            @dense_x_step writeOffset, y
            writeOffset = (writeOffset + width) % writeLength
            @copy_buffer writeOffset, y

        for y in [width-1..width-1]
            writeOffset = (writeOffset + width) % writeLength
            @copy_buffer writeOffset, y
        return

    copy_buffer: (writeOffset, y)->
        # Copy the write buffer
        dst = (y - 1) * @size_[0]
        i = @size_[0] - 1

        while i >= 1
            @data[dst + i] = @write[writeOffset + i]
            i -= 1
        return

    @equal: (x, y)->
        if x == y
            return true

        if x.hash != y.hash
            return false

        if x.data.length != y.data.length
            return false

        for i in [0...x.data.length]
            if x.data[i] != y.data[i]
                return false

        return true

class CycleFinderHash
    constructor: (@parent)->
        @hashHistory = Set.create()

    step: ->
        if @hashHistory.has @parent.simulator.hash
            return true
        else
            @hashHistory.add @parent.simulator.hash
            return false

class CycleFinderTortoiseHare
    constructor: (@parent)->
        @hare = @parent.simulator.clone()

    step: ->
        @hare.step()
        @hare.step()
        if DenseSim.equal @hare, @parent.simulator
            @length = @hare.generation - @parent.simulator.generation
            return true
        return false

class CellularAutomata
    constructor: ({rules, size})->
        rules = rules()

        @simulator = new DenseSim rules, size

        @timewarp = false

        @cycleFindingStrategies = [
            CycleFinderHash
            CycleFinderTortoiseHare
        ]
        @cycleFindingStrategy = 0
        @nextCycleFinder()

    nextCycleFinder: ->
        if @cycleFindingStrategy >= @cycleFindingStrategies.length
            console.log "Found cycle with length #{@cycleFinder.length}"

            @timewarp = true
            @timewarpLength = @cycleFinder.length

            @cycleFinder = null
            return true
        else
            @cycleFinder = new @cycleFindingStrategies[@cycleFindingStrategy] this
            @cycleFindingStrategy += 1
            return false

    load: (data)->
        @simulator.load data

    step: (n = 1)->
        if @timewarp
            # Warp n steps and simulate the rest
            console.log "Warping... #{n}"
            n = n % @timewarpLength

        if @cycleFinder?
            for i in [1..n]
                @simulator.step()

                # We've just found a cycle
                if @cycleFinder.step()
                    if @nextCycleFinder()
                        @step n - i
                        return
        else
            for i in [1..n]
                @simulator.step()
        return

OPEN = 0
EMPTY = 1
OCCUPIED = 2
symbols = '.L#'

ca = new CellularAutomata
    size: [100, 100]
    rules: ->
        rules = []
        rules[OPEN]     = (counts)-> OPEN
        rules[EMPTY]    = (counts)-> if counts[OCCUPIED] == 0 then OCCUPIED else EMPTY
        rules[OCCUPIED] = (counts)-> if counts[OCCUPIED] >= 4 then EMPTY else OCCUPIED
        return rules

ca.load data
ca.step 1000000
#ca.step 10000

chain ca.simulator.data,
    Arr.filter (x)-> x == OCCUPIED
    get 'length'
    console.log

NOTHING = 0
EMPTY = 1
FULL  = 2

chain data,
    CA.create.fromGrid
        symbols: '.L#'
        rules:
            [EMPTY]: (data)->
                for y in [-1 .. 1]
                    for x in [-1 .. 1]
                        if data.get(x, y) == FULL
                            return
                data.change(FULL)

            [EMPTY]: (data)->
                for y in [-1 .. 1]
                    for x in [-1 .. 1]
                        if data.rayCast(x, y) == FULL
                            return
                data.change(FULL)