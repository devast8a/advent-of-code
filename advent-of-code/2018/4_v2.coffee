{chain, pluck} = require 'sweet-coffee'
Arr = require 'sweet-coffee/arr'
Fs = require 'sweet-coffee/fs'
Map = require 'sweet-coffee/map'
Regex = require 'sweet-coffee/regex'
Str = require 'sweet-coffee/str'

guards = chain '4.txt',
    # Read input
    Fs.readFile
    Str.trim
    Str.split '\n'

    # Convert input into list of events
    Arr.sortA
    Arr.map Regex.exec /:(\d+)\] (.+)/
    Arr.map ([_, min, event])-> {min: parseInt(min), event: event}

    # Group events by shift
    Arr.splitBy ({event})-> event.endsWith 'begins shift'
    Arr.reject Arr.isEmpty

    # For each shift calculate minutes asleep/awake
    Arr.map (events)->
        time = Arr.filled 60, 0
        for i in [1...events.length] by 2
            for min in [events[i].min...events[i+1].min]
                time[min] += 1
        return {id: events[0].event, time: time}

    # Group by each guard and sum time asleep
    Arr.groupBy pluck 'id'
    Map.values.map Arr.sumBy pluck 'time'

for fn in [Arr.sum, Arr.max]
    guard = Map.values.maxBy fn, guards
    id = /\d+/.exec(guard.key)[0]
    min = Arr.maxBy(pluck(0), Arr.withIndexes(guard.value))[1]
    console.log id, min, id * min
