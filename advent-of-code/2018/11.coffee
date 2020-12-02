fuelCellValue = (serial, x, y)->
    rackId = x + 10

    power = rackId * y
    power += serial
    power *= rackId

    return power

fuelCellValue2 = (s, x, y)->
    # (((x + 0) + 10) * (y + 0) + s) * ((x + 0) + 10)
    s_2 = Math.floor (s % 1000) / 100
    s_1 = Math.floor (s %  100) / 10
    s_0 = Math.floor (s %   10)

    x_2 = Math.floor (x % 1000) / 100
    x_1 = Math.floor (x %  100) / 10
    x_0 = Math.floor (x %   10)

    y_2 = Math.floor (y % 1000) / 100
    y_1 = Math.floor (y %  100) / 10
    y_0 = Math.floor (y %   10)

    # r = x + 10
    r_2 = (x_2 + 0) * 10**2
    r_1 = (x_1 + 1) * 10**1
    r_0 = (x_0 + 0) * 10**0

    # p = r * y
    p_2 = r_0 * (y_2 * 10**2) +
          r_1 * (y_1 * 10**1) +
          r_2 * (y_0 * 10**0)

    p_1 = r_0 * (y_1 * 10**1) +
          r_1 * (y_0 * 10**0)

    p_0 = r_0 * (y_0 * 10**0)

    # p = p + s
    p_2 = p_2 + (s_2 * 10**2)
    p_1 = p_1 + (s_1 * 10**1)
    p_0 = p_0 + (s_0 * 10**0)

    # p *= r
    p_2 = r_0 * p_2 +
          r_1 * p_1 +
          r_2 * p_0

    p_1 = r_0 * p_1 +
          r_1 * p_0

    p_0 = r_0 * p_0

    # Just need to handle carries and overflows

    # ((x + 10) * y + serial) * (x + 10)
    # ((x + 10) * y + serial) * x + ((x + 10) * y + serial) * 10
    # (x + 10) * y * x + serial * x + (x + 10) * y * 10 + serial * 10
    # (x + 10)*y*x + serial*x + (x + 10)*y*10 + serial*10
    # x*y*x + 10*y*x + serial*x + x*y*10 + 10*y*10 + serial*10
    return p_2 + p_1 + p_0

fuelCellValue2 = (s, x, y)->
    # Setup parameters
    s_2 = Math.floor (s % 1000) / 100
    s_1 = Math.floor (s %  100) / 10
    s_0 = Math.floor (s %   10)

    x_2 = Math.floor (x % 1000) / 100
    x_1 = Math.floor (x %  100) / 10
    x_0 = Math.floor (x %   10)

    y_2 = Math.floor (y % 1000) / 100
    y_1 = Math.floor (y %  100) / 10
    y_0 = Math.floor (y %   10)

    # p = x * x
    p_2 = x_0 * x_2 +
          x_0 * x_2 +
          x_1 * x_1 +
          x_1 +
          x_1

    p_1 = x_0 * x_1 +
          x_0 * x_1 +
          x_0 +
          x_0

    # 0  1  4  9 16 25 36 39 64 81
    # Ones digit only: 1, 4, 5, 6, 9
    p_0 = x_0 * x_0

    # p = p * y
    p_2 = p_0 * y_2 +
          p_1 * y_1 +
          p_2 * y_0

    p_1 = p_0 * y_1 +
          p_1 * y_0

    p_0 = p_0 * y_0

    # a = s * (x + 10)
    a_2 = s_0 * x_2 +
          s_1 * x_1 +
          s_2 * x_0 +
          s_1

    a_1 = s_0 * x_1 +
          s_1 * x_0 +
          s_0

    a_0 = s_0 * x_0

    # p = p + a
    p_2 = p_2 + a_2
    p_1 = p_1 + a_1
    p_0 = p_0 + a_0

    # Moved crap around
    p_2 = p_2 + y_0

    # Place digits correctly
    p_2 *= 10**2
    p_1 *= 10**1
    p_0 *= 10**0

    return p_2 + p_1 + p_0


total = 0
errors = 0

for s in [0...1000]
    values = []

    for x in [0...300]
        for y in [0...300]
            values.push Math.floor(fuelCellValue(s, x, y) % 1000 / 100) - 5

    # Find the x y position of the maximum value
    max = [0, 0, 0]
    for size in [1...20]
        for x in [0...300 - size]
            for y in [0...300 - size]
                v = 0
                
                for xi in [0...size]
                    for yi in [0...size]
                        v += values[(y + yi) + 300*(x + xi)]

                if v > max[0]
                    max = [v, s, x, y, size]

    console.log max

console.log errors, total, errors / total
