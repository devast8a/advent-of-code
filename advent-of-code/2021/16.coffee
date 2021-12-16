{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque, Set} = require 'sweet-coffee/all'
Vec2d = require 'sweet-coffee/vec2d'
aoc = require '../aoc'

aoc
.setup
    date: '2021/16'
    tests: []
.solve (input)->
    input = chain input,
        Str.trim
        Str.split ''
        Arr.map Num.parseHex
        Arr.flatMap (x) -> [3..0].map (n)-> (x >> n) & 1

    ZERO = BigInt 0
    ONE  = BigInt 1
    FOUR = BigInt 4

    class BitStream
        constructor: (@bits)->
            @length = @bits.length
            @index = 0

        read: (size)->
            @index += size
            result = 0
            for bit in @bits[@index - size...@index]
                result = (result << 1) | bit
            return result

    combine = (values)->

    input = new BitStream input

    limitPackets = (packets)->
        return -> --packets >= 0

    limitBits = (bits)->
        bits += input.index
        return -> input.index < bits

    part1 = 0
    parse = (morePackets)->
        while morePackets()
            version = input.read 3
            type    = input.read 3
            part1  += version

            switch type
                when 4
                    value = ZERO
                    while true
                        next = input.read 1
                        value = (value << FOUR) | BigInt input.read 4
                        break if next == 0
                    value

                else
                    packets = []
                    switch input.read 1
                        when 0 then packets = parse limitBits input.read 15
                        when 1 then packets = parse limitPackets input.read 11

                    switch type
                        when 0 then packets.reduce (a, b)-> a + b
                        when 1 then packets.reduce (a, b)-> a * b
                        when 2 then Arr.min packets
                        when 3 then Arr.max packets
                        when 5 then (if packets[0]  > packets[1] then ONE else ZERO)
                        when 6 then (if packets[0]  < packets[1] then ONE else ZERO)
                        when 7 then (if packets[0] == packets[1] then ONE else ZERO)

    result = parse limitPackets 1

    return {
        part1: part1
        part2: Number result[0]
    }