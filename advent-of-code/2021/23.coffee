{_, chain, compose, curry, get, Arr, Fs, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
{Vec2, Vec3, Box3} = require 'sweet-coffee/vec'
aoc = require '../aoc'

aoc
.setup
    date: '2021/23'
    tests: [
        string: """
            #############
            #...........#
            ###B#C#B#D###
            ..#A#D#C#A#..
            ..#########..
        """
        part1: 12521
        part2: 44169
    ]
.solve (input)->
    input = input.trim()
    EMPTY = null

    solve = (part2)->
        data = [
            {home: 0, costs: [0,1,3,6,3,5,8,5,7,10,7,9,12,9,10,4,5,6,7,8,9,10,11],      neighbors: [1]}         #  0
            {home: 0, costs: [1,0,2,5,2,4,7,4,6,9,6,8,11,8,9,3,4,5,6,7,8,9,10],         neighbors: [0,2,4]}     #  1
            {home: 1, costs: [3,2,0,3,2,4,7,4,6,9,6,8,11,8,9,1,2,5,6,7,8,9,10],         neighbors: [1,15,4]}    #  2
            {home: 1, costs: [6,5,3,0,5,7,10,7,9,12,9,11,14,11,12,2,1,8,9,10,11,12,13], neighbors: [16]}        #  3
            {home: 0, costs: [3,2,2,5,0,2,5,2,4,7,4,6,9,6,7,3,4,3,4,5,6,7,8],           neighbors: [1,2,5,7]}   #  4
            {home: 2, costs: [5,4,4,7,2,0,3,2,4,7,4,6,9,6,7,5,6,1,2,5,6,7,8],           neighbors: [4,17,7]}    #  5
            {home: 2, costs: [8,7,7,10,5,3,0,5,7,10,7,9,12,9,10,8,9,2,1,8,9,10,11],     neighbors: [18]}        #  6
            {home: 0, costs: [5,4,4,7,2,2,5,0,2,5,2,4,7,4,5,5,6,3,4,3,4,5,6],           neighbors: [4,5,8,10]}  #  7
            {home: 3, costs: [7,6,6,9,4,4,7,2,0,3,2,4,7,4,5,7,8,5,6,1,2,5,6],           neighbors: [7,19,10]}   #  8
            {home: 3, costs: [10,9,9,12,7,7,10,5,3,0,5,7,10,7,8,10,11,8,9,2,1,8,9],     neighbors: [20]}        #  9
            {home: 0, costs: [7,6,6,9,4,4,7,2,2,5,0,2,5,2,3,7,8,5,6,3,4,3,4],           neighbors: [7,8,11,13]} # 10
            {home: 4, costs: [9,8,8,11,6,6,9,4,4,7,2,0,3,2,3,9,10,7,8,5,6,1,2],         neighbors: [10,21,13]}  # 11
            {home: 4, costs: [12,11,11,14,9,9,12,7,7,10,5,3,0,5,6,12,13,10,11,8,9,2,1], neighbors: [22]}        # 12
            {home: 0, costs: [9,8,8,11,6,6,9,4,4,7,2,2,5,0,1,9,10,7,8,5,6,3,4],         neighbors: [10,11,14]}  # 13
            {home: 0, costs: [10,9,9,12,7,7,10,5,5,8,3,3,6,1,0,10,11,8,9,6,7,4,5],      neighbors: [13]}        # 14
            {home: 1, costs: [4,3,1,2,3,5,8,5,7,10,7,9,12,9,10,0,1,6,7,8,9,10,11],      neighbors: [2,16]}      # 15
            {home: 1, costs: [5,4,2,1,4,6,9,6,8,11,8,10,13,10,11,1,0,7,8,9,10,11,12],   neighbors: [15,3]}      # 16
            {home: 2, costs: [6,5,5,8,3,1,2,3,5,8,5,7,10,7,8,6,7,0,1,6,7,8,9],          neighbors: [5,18]}      # 17
            {home: 2, costs: [7,6,6,9,4,2,1,4,6,9,6,8,11,8,9,7,8,1,0,7,8,9,10],         neighbors: [17,6]}      # 18
            {home: 3, costs: [8,7,7,10,5,5,8,3,1,2,3,5,8,5,6,8,9,6,7,0,1,6,7],          neighbors: [8,20]}      # 19
            {home: 3, costs: [9,8,8,11,6,6,9,4,2,1,4,6,9,6,7,9,10,7,8,1,0,7,8],         neighbors: [19,9]}      # 20
            {home: 4, costs: [10,9,9,12,7,7,10,5,5,8,3,1,2,3,4,10,11,8,9,6,7,0,1],      neighbors: [11,22]}     # 21
            {home: 4, costs: [11,10,10,13,8,8,11,6,6,9,4,2,1,4,5,11,12,9,10,7,8,1,0],   neighbors: [21,12]}     # 22
        ]
        init     = [-1,-1,31,45,-1,33,47,-1,35,49,-1,37,51,-1,-1]
        init = init.map (index)-> if index == -1 then EMPTY else input[index]

        if part2
            init = init.concat ...'DDCBBAAC'

        init = init.map (value)->
            return switch value
                when 'A' then {type: 1, cost: 1, moved: false}
                when 'B' then {type: 2, cost: 10, moved: false}
                when 'C' then {type: 3, cost: 100, moved: false}
                when 'D' then {type: 4, cost: 1000, moved: false}
                when EMPTY then EMPTY
                else throw new Error

        if not part2
            ns=[[1],[0,2,4],[1,3,4],[2],[1,2,5,7],[4,6,7],[5],[4,5,8,10],[7,9,10],[8],[7,8,11,13],[10,12,13],[11],[10,11,14],[13]]
            for n,i in ns
                data[i].neighbors=n
            data = data.slice 0, ns.length
            compute_cost init, data


        cache = new Map

        move = (state, start, end)->
            state = state.map (crab)->
                return EMPTY if crab == EMPTY
                return Object.assign {}, crab
            state[end]   = state[start]
            state[end].moved = true
            state[start] = EMPTY
            return state
        
        cost = (state, start, end)->
            return data[start].costs[end]

        state_to_key = (state)->
            return state.map (crab)->
                return 'EMPTY' if crab == EMPTY
                return "#{crab.type}-#{crab.moved}"
            .join '|'

        done = (state)->
            return state.every (crab, index)-> crab == EMPTY or data[index].home == crab.type

        search = (state, c_cost)->
            key = state_to_key state

            if cache.has key
                return cache.get key

            if done state
                cache.set key, 0
                return 0

            if c_cost > 50000
                cache.set key, null
                return null

            results = []
            for crab, start in state
                continue if crab == EMPTY

                for end in neighbors state, start, crab
                    # Mutate the state
                    n_state = move state, start, end
                    n_cost  = cost state, start, end
                    result  = search n_state, c_cost + n_cost * crab.cost

                    # Found dead end
                    if result == null
                        continue

                    results.push result + n_cost * crab.cost
            
            # Found dead end
            if results.length == 0
                cache.set key, null
                return null

            # Return cost
            result = Arr.min results
            cache.set key, result
            return result

        neighbors = (state, start, crab)->
            seen = new Set [start]
            open = [start]
            output = []

            # Crab is already home
            if data[start].home == crab.type and crab.moved
                return output

            while open.length > 0
                for tile in data[open.pop()].neighbors

                    if seen.has tile
                        continue
                    seen.add tile

                    # Crabs can not pass through each other
                    if state[tile] != EMPTY
                        continue

                    # Crab can always move to its home
                    if data[tile].home == crab.type
                        output.push tile
                    
                    # Crab can move to a hallway tile only if it hasn't moved
                    if data[tile].home == 0 and not crab.moved
                        output.push tile

                    open.push tile

            return output

        return search init, 0, []

    return {
        part1: solve false
        part2: solve true
    }

compute_cost = (init, data)->
    hallways = [[1,2],[1,4],[2,4],[4,5],[4,7],[5,7],[7,8],[7,10],[8,10],[10,11],[10,13],[11,13]]
    graph = chain data,
        Arr.flatMap ({neighbors}, start)->
            neighbors.map (end)-> [start, end]
        Graph.fromUndirectedEdges
    for x in [0...init.length]
        data[x].costs = costs = []
        for y in [0...init.length]
            path = Graph.findPath x, y, graph
            cost = path.length - 1
            for first, index in path
                if index < path.length - 1
                    second = path[index + 1]
                    for [a, b] in hallways
                        if first.key == a and second.key == b
                            cost++
                        if first.key == b and second.key == a
                            cost++
            costs.push cost