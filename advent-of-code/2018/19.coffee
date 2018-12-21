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
#Set = require 'sweet-coffee/container/set'

registerNames = ['a', 'b', 'c', 'd', 'e', 'f']
registerCount = 6

COMPARE = 0x01
CONTROL = 0x02

ops = []

# Arithmetic instructions
binaryOperations = [
    ['add', '+', Op.add]
    ['mul', '*', Op.mul]
    ['ban', '&', Op.andB]
    ['bor', '|', Op.orB]
]

for [name, op, fn] in binaryOperations
    do (op, fn)->
        ops.push
            name: "#{name}r"
            flags: 0
            inRegisters: [0, 1]
            compile: (a, b)-> "#{a} #{op} #{b}"
            interpret: (state, a, b, c)-> state[c] = fn state[a], state[b]

        ops.push
            name: "#{name}i"
            flags: 0
            inRegisters: [0]
            compile: (a, b)-> "#{a} #{op} #{b}"
            interpret: (state, a, b, c)-> state[c] = fn state[a], b

# Set instructions
ops.push
    name: "setr"
    flags: 0
    inRegisters: [0]
    compile: (a, b)-> "#{a}"
    interpret: (state, a, b, c)-> state[c] = state[a]

ops.push
    name: "seti"
    flags: 0
    inRegisters: []
    compile: (a, b)-> "#{a}"
    interpret: (state, a, b, c)-> state[c] = a

# Comparison instructions
comparisonOperations = [
    ['gt', '>',  Op.gt, '<=', Op.lte]
    ['eq', '==', Op.eq, '!=', Op.neq]
]

for [name, op, fn, iop, ifn] in comparisonOperations
    do (op, fn, iop, ifn)->
        ops.push
            name: "#{name}ri"
            flags: COMPARE
            inRegisters: [0]
            compile: (a, b)-> "#{a} #{op} #{b}"
            invertCompile: (a, b)-> "#{a} #{iop} #{b}"
            interpret: (state, a, b, c)-> state[c] = if fn(b, state[a]) then 1 else 0

        ops.push
            name: "#{name}ir"
            flags: COMPARE
            inRegisters: [1]
            compile: (a, b)-> "#{a} #{op} #{b}"
            invertCompile: (a, b)-> "#{a} #{iop} #{b}"
            interpret: (state, a, b, c)-> state[c] = if fn(state[b], a) then 1 else 0

        ops.push
            name: "#{name}rr"
            flags: COMPARE
            inRegisters: [0, 1]
            compile: (a, b)-> "#{a} #{op} #{b}"
            invertCompile: (a, b)-> "#{a} #{iop} #{b}"
            interpret: (state, a, b, c)-> state[c] = if fn(state[b], state[a]) then 1 else 0

# Additional instructions (We use them when we JIT the program)
JUMP = {
    name: 'jump'
    flags: CONTROL
}
ops.push JUMP

BRANCH = {
    name: 'branch'
    flags: CONTROL
}
ops.push BRANCH

LOOP = {
    name: 'loop'
    flags: CONTROL
}
ops.push LOOP

NOP = {
    name: 'nop'
    flags: 0
}
ops.push NOP

names = Arr.map get('name'), ops

# Parse input
[ip, program...] = chain '19.txt',
    Fs.readFile
    Str.trim
    Str.split '\n'

    Arr.map (instruction, offset)->
        [name, args...] = instruction.split ' '
        return {
            offset: offset - 1
            op: ops[names.indexOf name]
            args: args.map Num.parseDec
        }

jit = (program)->
    # Find instructions writing to instruction pointer
    ip = ip.args[0]

    writesToIp = program.filter ({args})->args[2] == ip

    # Any direct jumps are okay
    for instruction in writesToIp
        if (not instruction.op.compare) and dependsOn instruction, [ip]
            state = Arr.filled registerCount, 0
            state[ip] = instruction.offset
            instruction.op.interpret state, instruction.args...

            instruction.op = JUMP
            instruction.args = [state[ip] + 1]

    # Compare/jump elimination
    for compare, offset in program
        unless (compare.op.flags & COMPARE) > 0
            continue

        temp = compare.args[2]

        jump = program[offset + 1]
        a = program[offset + 2]
        b = program[offset + 3]

        unless jump and jump.op.name == 'addr' and jump.args[2] == ip
            continue

        unless (jump.args[0] == ip and jump.args[1] == temp) or (jump.args[0] == temp and jump.args[1] == ip)
            continue

        if a.op != JUMP
            continue

        compare.args = compare.args[..-2]
        compare.args.unshift compare.op.name
        compare.compare = compare.op

        compare.op = BRANCH

        jump.handled = true
        jump.op = NOP
        jump.args = []

        a.op = NOP
        compare.args.push a.args[0]
        a.args = []

        if b.op == JUMP
            b.op = NOP
            compare.args.push b.args[0]
            b.args = []
        else
            compare.args.push offset + 3

    writesToIp = writesToIp.filter ({op})-> not ((op.flags & CONTROL) > 0 or op == NOP)

    # Assume that a single jump depending on only [ip, 0] is safe
    if writesToIp.length == 1 and dependsOn(writesToIp[0], [ip, 0])
        [input] = writesToIp

        a = program[input.offset + 1]
        b = program[input.offset + 2]

        if a.op == JUMP
            input.handled = true
            input.op = BRANCH
            input.args = ['eqri', 0, 1]
            input.compare = ops[13]

            a.op = NOP
            input.args.push a.args[0]
            a.args = []

            if b.op == JUMP
                b.op = NOP
                input.args.push b.args[0]
                b.args = []
            else
                input.args.push input.offset + 2
            writesToIp = []

    if writesToIp.length > 0
        console.log "Error: Access to instruction pointer could not be converted to jump/branch"
        return

    # Build a control flow graph
    for instruction in program
        switch instruction.op
            when JUMP
                offset = instruction.args[0]
                if 0 <= offset < program.length
                    program[offset].isJumpTarget = true

            when BRANCH
                offset = instruction.args[3]
                if 0 <= offset < program.length
                    program[offset].isJumpTarget = true

                offset = instruction.args[4]
                if 0 <= offset < program.length
                    program[offset].isJumpTarget = true

    block = {
        id: 0
        instructions: []
        edges: []
        stopInstructions: []
    }
    blocks = [block]

    for instruction, offset in program
        block.instructions.push instruction

        if (offset + 1 < program.length) and program[offset + 1].isJumpTarget
            block = {
                id: blocks.length
                instructions: []
                edges: []
                stopInstructions: []
            }
            blocks.push block

        if (instruction.op.flags & CONTROL) > 0
            block = {
                id: blocks.length
                instructions: []
                edges: []
                stopInstructions: []
            }
            blocks.push block

    # Remove NOPs
    blocks = blocks.filter (block)->
        return not block.instructions.every ({op})-> op == NOP

    # Change the block ids
    blocks.forEach (block, index)->
        block.id = index

    lastBlock = {
        id: blocks.length
        instructions: []
        edges: []
        stop: true
        stopInstructions: ['return a;']
    }

    # Link up blocks
    offsetToBlock = new Array program.length

    for block in blocks
        offsetToBlock[block.instructions[0].offset] = block

    for block, index in blocks
        last = block.instructions[block.instructions.length - 1]

        switch last.op
            when JUMP
                block.edges.push offsetToBlock[last.args[0]] ? lastBlock

            when BRANCH
                block.edges.push offsetToBlock[last.args[3]] ? lastBlock
                block.edges.push offsetToBlock[last.args[4]] ? lastBlock

            else
                block.edges.push blocks[index + 1] ? lastBlock

    # Find loops, we assume loops only have one entry point
    loops = []
    cfg = chain blocks,
        Arr.flatMap (block)->
            block.edges.map (other)-> [block, other]
        DirectedGraph.create.fromEdges

    chain cfg,
        DirectedGraph.depthFirstPath [blocks[0]], (current, path)->
            if path.indexOf(current) != path.length - 1
                loops.push [
                    path[path.length - 2].key.id
                    current.key.id
                    path.length
                ]
                return []
            return current.outEdges

    # Detect where the loop starts and ends
    # We also don't handle multiple back-edges or exits (continue/break)
    #   So detect those and bailout if we need to
    srcToDst = new Array blocks.length + 1
    dstToSrc = new Array blocks.length + 1
    distance = new Array blocks.length + 1

    for [src, dst, length] in loops
        if srcToDst[src]? and srcToDst[src] != dst
            console.log "Error: Can't handle loops with multiple back-edges"
            return

        if dstToSrc[dst]? and dstToSrc[dst] != src
            console.log "Error: Can't handle loops with multiple back-edges"
            return

        blocks[src].loopBegin = blocks[dst]

        srcToDst[src] = dst
        dstToSrc[dst] = src
        distance[src] = Math.max distance[src] ? length, length

    for dst, src in srcToDst
        unless dst?
            continue

        instructions = blocks[src].instructions
        instructions[instructions.length - 1].op = LOOP

    # We emit code from both sides of a branch.
    # When those branches control flow join and begin executing common code,
    #   the compilation algorithm will emit two copies of that code.
    # Find those joins and keep note of them for later
    for block in blocks
        if block.instructions[block.instructions.length - 1].op == BRANCH
            block.after = findJoinAfterBranch block

    # Compile non-control instructions
    blocks = chain blocks,
        Arr.forEach (block)->
            block.instructions = chain block.instructions,
                Arr.map (instruction)->
                    if (instruction.op.flags & CONTROL) == 0
                        return compile instruction, ip
                    else
                        return instruction

    # We really want to compile most deeply nested loops to least deeply
    #   but for now we compile loops that can be accessed first
    #   although they might be equivelent.
    distance = chain distance,
        Arr.withIndexes
        Arr.filter (x)->x[0]?
        Arr.sortABy (x)->x[0]
        Arr.forEach ([distance, index])->
            compileLoop blocks[index]

    # Compile the code from our entry point
    output = compileBlock blocks[0]
    output.push 'return a;'

    # Inject optimization that speeds up code
    [_, a, b] = /(\w)\s\*\s(\w)/.exec output[22]
    [_, _, c] = /(\w)\s\==\s(\w)/.exec output[23]
    [_, d, _] = /(\w)\s\+\s([\w\d])/.exec output[26]
    if d == a then a = b
    output.splice 21, 0, ["    if((#{c} % #{a}) != 0){#{a} = #{a} + 1; continue}"]

    code = output.join '\n'

    return new Function(registerNames..., code)

indent = (instruction)-> "    " + instruction

dependsOn = ({op, args}, registers)->
    for parameter in op.inRegisters
        if registers.indexOf(args[parameter]) < 0
            return false
    return true

# Compile a given instruction into javascript
compile = (instruction, ip)->
    args = instruction.args.slice 0
    for register in instruction.op.inRegisters
        if args[register] == ip
            args[register] = instruction.offset
        else
            args[register] = registerNames[args[register]]


    dst = registerNames[args[2]]
    code = instruction.op.compile args[0], args[1]

    return "#{dst} = #{code};"

# Compile a given comparison instruction (used in control flow) into javascript
compileControl = (instruction, invert)->
    args = instruction.args[1..2]

    for register in instruction.compare.inRegisters
        if args[register] == ip
            args[register] = instruction.offset
        else
            args[register] = registerNames[args[register]]

    if invert
        return instruction.compare.invertCompile args[0], args[1]
    else
        return instruction.compare.compile args[0], args[1]

# Compile a block that ends in a loop instruction into javascript
#   You must compile loops from most deeply nested to least deeply nested
compileLoop = (block)->
    block.stop = true

    [body..., last] = block.instructions

    condition = compileControl last, true

    instructions = [
        "do {"
        compileBlock(block.edges[0]).map(indent)...
        body.map(indent)...
        "} while(#{condition}); "
    ]

    block.stop = false

    # We make the assumption that no other control flows into the loop
    # Whatever our entrypoint into the loop is
    block.loopBegin.stopInstructions = instructions
    block.loopBegin.stop = true

    return instructions

# Compile a block of code into javascript
#   Make sure you have called compileLoop on all loops and findJoinAfterBranch on all branches
compileBlock = (block, stop)->
    #console.log block
    if block.stop or block == stop
        return block.stopInstructions

    [instructions..., last] = block.instructions

    switch last.op
        when BRANCH
            # TODO: The detection on this needs to be a lot less crap
            addFollowingInstructions = stop == undefined
            stop ?= block.after

            trueBranch = compileBlock(block.edges[1], stop).map(indent)
            falseBranch = compileBlock(block.edges[0], stop).map(indent)

            if trueBranch.length > 0
                condition = compileControl last
                instructions.push "if(#{condition}){"
                instructions = instructions.concat trueBranch

                if falseBranch.length > 0
                    instructions.push "} else {"
                    instructions = instructions.concat falseBranch
            else
                condition = compileControl last, true
                instructions.push "if(#{condition}){"
                instructions = instructions.concat falseBranch

            instructions.push "}"

            if addFollowingInstructions
                instructions = instructions.concat compileBlock(block.after)

        when JUMP
            instructions = instructions.concat compileBlock block.edges[0], stop

        when LOOP
            throw new Error "???"

        else
            instructions.push last
            instructions = instructions.concat compileBlock block.edges[0], stop

    return instructions

# Finds the point after a branch where control flow joins back up again
findJoinAfterBranch = (block)->
    [x, y] = block.edges

    xpath = []
    ypath = []

    while xpath.indexOf(y) < 0 and ypath.indexOf(x) < 0
        xpath.push x
        ypath.push y

        x = follow x
        y = follow y

    return xpath[xpath.indexOf y] ? ypath[ypath.indexOf x]

# Return the block that control flow goes to after the current block
#   Only returns a value for non-branching control flow
follow = (block, visited)->
    if block.stop then return null

    last = block.instructions[block.instructions.length - 1]

    switch last.op
        when BRANCH
            return null

        when LOOP
            return block.edges[1]

        else
            return block.edges[0]

fn = jit program
console.log fn 0, 0, 0, 0, 0, 0
console.log fn 1, 0, 0, 0, 0, 0
