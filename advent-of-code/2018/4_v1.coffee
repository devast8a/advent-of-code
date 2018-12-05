{chain, pluck} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
SMap = require 'sweet-coffee/map'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

guards = chain '4.txt',
    # Read
    Fs.readFile
    Str.split '\n'
    Arr.map Str.trim
    Arr.filter (x)->x.length > 0

    # Process
    Arr.sortA
    Arr.map Regex.exec /\[(\d+\-\d+\-\d+) \d+:(\d+)\] (.+)/

    # Events to guard sleeping times
    (events)->
        guards = new Map
        startTime = 0
        for [_, date, min, event] in events
            min = parseInt min, 10

            if event == 'falls asleep'
                startTime = min
            else if event == 'wakes up'
                guard.sleep.push
                    date: date
                    start: startTime
                    end: min
                    time: min - startTime
            else
                guard = guards.get event
                if not guard?
                    guard =
                        sleep: []
                        id: parseInt /\d+/.exec(event)[0]
                    guards.set event, guard
        return Array.from guards.values()
    Arr.map (guard)->
        guard.total = Arr.sumBy pluck('time'), guard.sleep

        guard.minutes = chain guard.sleep,
            Arr.groupBy pluck('date')
            SMap.values
            Arr.map (day)->
                chain [0..60], Arr.map (min)->
                    for sleep in day
                         if min >= sleep.start and min < sleep.end
                             return 1
                    return 0

            # Element wise sum
            Arr.foldR Arr.filled(60, 0), (x, y)->
                Arr.map2 ((x, y)->x + y), x, y

            Arr.map (value, index)->
                slept: value
                minute: index

        return guard

# Part 1
guard = Arr.maxBy pluck('total'), guards
console.log guard
{minute} = Arr.maxBy pluck('slept'), guard.minutes
console.log guard.id, minute, guard.id * minute

# Part 2
[guard, {minute}] = chain guards,
    Arr.map (guard)->
        minute = chain guard.minutes,
            Arr.maxBy pluck('slept')
        return [guard, minute]
    Arr.maxBy pluck('1.slept')
console.log guard.id, minute, guard.id * minute
