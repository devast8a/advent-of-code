{curry} = require 'sweet-coffee'
fs = require 'fs'
http = require 'https'
child_process = require 'child_process'

session = fs.readFileSync "#{__dirname}/session.txt", 'utf-8'
session = session.trim()

exported = {}

https_get = (url, options)->
    new Promise (resolve, reject)->
        req = http.get url, options, (res)->
            if res.statusCode == 200
                res.on 'data', (data)->
                    resolve data
            else
                reject res.statusCode

exported.get =
get = (date)->
    [year, day] = date.split '/'
    file = "#{day}.txt"

    # Read the file if it already exists
    try
        contents = fs.readFileSync file, 'utf-8'
        return contents
    catch

    # Otherwise download it from the server
    url = "https://adventofcode.com/#{year}/day/#{day}/input"

    # TODO: Need error recovery
    console.log "[AOC] Downloading #{date}"
    response = await https_get url, {
        headers: {
            cookie: "session=#{session}"
        }
    }

    data = response.toString 'utf-8'

    fs.writeFileSync file, data
    return data

exported.put =
put = curry (day, solution)->
    console.log day, solution

IN_TEST = false
exports.log =
log = (text)->
    if IN_TEST
        console.log text
    
exported.run =
run = (options)->
    data = await get options.date

    IN_TEST = true
    for test, index in options.tests
        result = options.solution test.string, test.parameters

        if test.part1 == result.part1
            console.log "✔️ Test #{index + 1}, Part 1"
        else
            console.log "❌ Test #{index + 1}, Part 1 | Expected: #{test.part1}  Got: #{result.part1}"

        if test.part2 == result.part2
            console.log "✔️ Test #{index + 1}, Part 2"
        else
            console.log "❌ Test #{index + 1}, Part 2 | Expected: #{test.part2}  Got: #{result.part2}"
    IN_TEST = false

    result = options.solution data, options.parameters

    if result.part1? and not result.part2?
        console.log "Part 1: #{result.part1} - copied to clipboard"
        console.log "Part 2: <no value>"
        child_process.spawn('clip.exe').stdin.end(result.part1.toString())
    else if result.part2?
        console.log "Part 1: #{result.part1 ? "<no value>"}"
        console.log "Part 2: #{result.part2} - copied to clipboard"
        child_process.spawn('clip.exe').stdin.end(result.part2.toString())
    else
        console.log "Part 1: <no value>"
        console.log "Part 2: <no value>"

exported.setup =
setup = (options)->
    options.solve = (solution)->
        options.solution = solution
        run options
    return options

module.exports = exported