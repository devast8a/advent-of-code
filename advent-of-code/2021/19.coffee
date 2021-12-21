{_, chain, compose, curry, get, Arr, Fs, Map, Num, Op, Regex, Str, Math, Graph, Deque} = require 'sweet-coffee/all'
{Mat3, Vec3} = require 'sweet-coffee/vec'
{Set} = require 'sweet-ts'
aoc = require '../aoc'

Set.intersection = curry (s1, s2)->
    output = Set.create()
    for value from s1
        if s2.has value
            output.add value
    return output

Set.fromArray = (array)->
    output = Set.create()
    for value in array
        output.add value
    return output

Obj = {}
Obj.add = curry (fn, obj)-> Object.assign {}, obj, fn obj

mutations = [
    ([x, y, z])-> [ x,  y,  z]
    ([x, y, z])-> [ x, -z,  y]
    ([x, y, z])-> [ x, -y, -z]
    ([x, y, z])-> [ x,  z, -y]

    ([x, y, z])-> [-z,  y,  x]
    ([x, y, z])-> [-y, -z,  x]
    ([x, y, z])-> [ z, -y,  x]
    ([x, y, z])-> [ y,  z,  x]

    ([x, y, z])-> [-x,  y, -z]
    ([x, y, z])-> [-x, -z, -y]
    ([x, y, z])-> [-x, -y,  z]
    ([x, y, z])-> [-x,  z,  y]

    ([x, y, z])-> [ z,  y, -x]
    ([x, y, z])-> [ y, -z, -x]
    ([x, y, z])-> [-z, -y, -x]
    ([x, y, z])-> [-y,  z, -x]

    ([x, y, z])-> [-y,  x,  z]
    ([x, y, z])-> [-z,  x, -y]
    ([x, y, z])-> [ y,  x, -z]
    ([x, y, z])-> [ z,  x,  y]

    ([x, y, z])-> [-z, -x,  y]
    ([x, y, z])-> [-y, -x, -z]
    ([x, y, z])-> [ z, -x, -y]
    ([x, y, z])-> [ y, -x,  z]
]

reverse = [
    ([x, y, z])-> [ x,  y,  z]
    ([x, y, z])-> [ x,  z, -y]
    ([x, y, z])-> [ x, -y, -z]
    ([x, y, z])-> [ x, -z,  y]

    ([x, y, z])-> [ z,  y, -x]
    ([x, y, z])-> [ z, -x, -y]
    ([x, y, z])-> [ z, -y,  x]
    ([x, y, z])-> [ z,  x,  y]

    ([x, y, z])-> [-x,  y, -z]
    ([x, y, z])-> [-x, -z, -y]
    ([x, y, z])-> [-x, -y,  z]
    ([x, y, z])-> [-x,  z,  y]

    ([x, y, z])-> [-z,  y,  x]
    ([x, y, z])-> [-z,  x, -y]
    ([x, y, z])-> [-z, -x, -y]
    ([x, y, z])-> [-z,  y, -x]

    ([x, y, z])-> [ y, -x,  z]
    ([x, y, z])-> [ y, -z, -x]
    ([x, y, z])-> [ y,  x, -z]
    ([x, y, z])-> [ y,  z,  x]

    ([x, y, z])-> [-y,  z, -x]
    ([x, y, z])-> [-y, -x, -z]
    ([x, y, z])-> [-y, -z,  x]
    ([x, y, z])-> [-y,  x,  z]
]

aoc
.setup
    date: '2021/19'
    tests: [
        string: """
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
        """
    ]
.solve (input)->
    START = Date.now()

    input = chain input,
        Str.trim
        Str.split '\n\n'

        # Parse scanners
        Arr.map (points, id)->
            id: id
            points: chain points,
                Str.split '\n'
                Arr.skip 1
                Arr.map compose [
                    Str.split ','
                    Arr.map Num.parseDec
                    ([x, y, z])-> Vec3.create x, y, z
                ]

        # Compute distance sets
        Arr.map Obj.add ({points})->
            set = Set.create()
            for x,i in points then for y in points[i+1..]
                set.add Vec3.distance.manhattan x, y
            return {distances: set}

        # Compute all mutations (all facings and rotations)
        Arr.map Obj.add ({points})->
            mutations: chain mutations,
                Arr.map (direction)-> points.map ({x, y, z})-> Vec3.create ...direction([x, y, z])

        # Compute translations
        Arr.map Obj.add ({mutations})->
            translations: chain mutations,
                Arr.map (points)->
                    translations = []
                    for point in points
                        translations.push [point, points.map (p)-> Vec3.sub p, point]
                    return translations

    overlapping = (a, b)->
        set = Set.create()
        for ai in a
            set.add ai
        count = 0
        for bi in b
            if set.has bi
                count++
        return count

    cache = Map.create()

    most_overlapping = (a, b)->
        # The point we consider to be 0,0,0
        most = 0
        best = 0

        azs = cache.get a
        if azs == undefined
            azs = []
            for az in a
                ax = a.map (ai)-> Vec3.sub ai, az
                azs.push [az, ax]
            cache.set a, azs

        bzs = cache.get b
        if bzs == undefined
            bzs = []
            for bz in b
                bx = b.map (bi)-> Vec3.sub bi, bz
                bzs.push [bz, bx]
            cache.set b, bzs

        for [az, ax] in azs
            for [bz, bx] in bzs
                score = overlapping ax, bx
                if score > most
                    most = score
                    best = [az, bz, ax, bx]
                    if score >= 12
                        break
        return [most, best]

    bdmap = Map.create()

    best_direction = (a, b)->
        output = bdmap.get b
        if output == undefined
            output = chain mutations,
                Arr.map (direction)-> b.map ({x, y, z})-> Vec3.create ...direction([x, y, z])

        chain output,
            Arr.map (b, index)->
                res = most_overlapping a, b
                res.push index
                return res
            Arr.sortDBy get 0
            get 0

    translations = []
    for x,i in input
        for y in input[i+1..]
            if x == y then continue
            if Set.intersection(x.distances, y.distances).size <= 70 then continue
            b = best_direction(x.points, y.points)
            if b < 12 then continue

            r = ({x,y,z}) -> Vec3.create ...reverse[b[2]] [x, y, z]

            edge = [
                x.id,
                y.id,
                {
                    translation:  Vec3.sub b[1][0], b[1][1]
                    translation2: Vec3.sub r(b[1][1]), r(b[1][0])
                    direction: mutations[b[2]]
                    direction2: reverse[b[2]]
                }
            ]

            console.log x.id, y.id

            translations.push edge

    points = []
    mapping = Map.create()
    mapping.set 0, (point)-> point
    for point in input[0].points
        points.push point

    scanners = []

    while mapping.size < input.length
        for [prev, next, data] in translations
            do (prev, next, data)->
                {translation, translation2, direction, direction2} = data
                if mapping.has(prev) and not mapping.has(next)
                    p = mapping.get prev
                    m = ({x, y, z})->
                        point = Vec3.create ...direction([x, y, z])
                        point = Vec3.add point, translation
                        return p point
                    mapping.set next, m
                    scanners.push p translation
                    for point in input[next].points
                        points.push m(point)
                else if mapping.has(next) and not mapping.has(prev)
                    p = mapping.get next
                    m = ({x, y, z})->
                        point = Vec3.create ...direction2([x, y, z])
                        point = Vec3.add point, translation2
                        return p point
                    mapping.set prev, m
                    scanners.push p translation2
                    for point in input[prev].points
                        points.push m(point)

    set = Set.create()
    for point in points
        set.add point
    part1 = set.size

    l = 0
    for x in scanners
        for y in scanners
            l = Math.max l, Vec3.distance.manhattan x, y
    part2 = l
    END = Date.now()
    console.log (END - START) / 1000

    console.log part1, part2

    return {
        part1,
        part2
    }