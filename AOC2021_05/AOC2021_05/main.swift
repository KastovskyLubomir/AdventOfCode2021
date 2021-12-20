//
//  main.swift
//  AOC2021_05
//
//  Created by Lubomír Kaštovský on 07.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

typealias intPoint = (x:Int, y:Int)

func internalBresenham(p1: intPoint, p2: intPoint, steep: Bool) -> [intPoint] {
    let dX = p2.x - p1.x
    let dY = p2.y - p1.y

    var points:[intPoint] = []

    let yStep           = (dY >= 0) ? 1 : -1
    let slope           = abs(Float(dY)/Float(dX))
    var error:Float     = 0
    var x               = p1.x
    var y               = p1.y

    points.append(steep ? (y, x) : (x, y))
    for x in x...p2.x {
        error += slope
        if (error >= 0.5) {
            y += yStep
            error -= 1
        }
        points.append(steep ? (y, x) : (x, y))
    }

    return points
}

//Was just for tests
func iround(_ v: CGFloat) -> Int {
    return Int(v)
}

// !! not working for diagonal, generates incorrect points
func bresenham(P1: NSPoint, P2: NSPoint) -> [intPoint] {

    var p1 = intPoint(iround(P1.x), iround(P1.y))
    var p2 = intPoint(iround(P2.x), iround(P2.y))

    //We need to handle the different octants differently
    let steep = abs(p2.y-p1.y) > abs(p2.x-p1.x)
    if steep {
        //Swizzle stuff around
        p1 = intPoint(x: p1.y, y: p1.x)
        p2 = intPoint(x: p2.y, y: p2.x)
    }
    if p2.x < p1.x {
        let tmp = p1
        p1 = p2
        p2 = tmp
    }

    return internalBresenham(p1: p1, p2: p2, steep: steep)
}

let lines = readLinesRemoveEmpty(str: inputString)

func generatePoints(line: String) -> Set<String> {
    let args = line.components(separatedBy: [","," "])
    let x1 = Int(args[0])!
    let y1 = Int(args[1])!
    let x2 = Int(args[3])!
    let y2 = Int(args[4])!
    let points = bresenham(P1: NSPoint(x: x1, y: y1), P2: NSPoint(x: x2, y: y2))
    var pointSet: Set<String> = []
    for point in points {
        let key = String(point.x) + "," + String(point.y)
        pointSet.insert(key)
    }
    return pointSet
}

func isOnlyVerticalOrHorizontal(line: String) -> Bool {
    let args = line.components(separatedBy: [","," "])
    let x1 = Int(args[0])!
    let y1 = Int(args[1])!
    let x2 = Int(args[3])!
    let y2 = Int(args[4])!

    return x1 == x2 || y1 == y2
}

func isDiagonal(line: String) -> Bool {
    let args = line.components(separatedBy: [","," "])
    let x1 = Int(args[0])!
    let y1 = Int(args[1])!
    let x2 = Int(args[3])!
    let y2 = Int(args[4])!
    let xdiff = abs(x2 - x1)
    let ydiff = abs(y2 - y1)
    return xdiff == ydiff
}

func generateDiagonal(line: String) -> Set<String> {
    let args = line.components(separatedBy: [","," "])
    let x1 = Int(args[0])!
    let y1 = Int(args[1])!
    let x2 = Int(args[3])!
    let y2 = Int(args[4])!
    var xaddition = 1
    var yaddition = 1
    if x1 > x2 {
        xaddition = -1
    }
    if y1 > y2 {
        yaddition = -1
    }
    var result: Set<String> = []
    var xx = x1
    var yy = y1
    var i = 0
    while i <= abs(x2 - x1) {
        let point = String(xx) + "," + String(yy)
        result.insert(point)
        xx += xaddition
        yy += yaddition
        i += 1
    }
    return result
}

func findIntersections(lines: [String], verticalHorizontal: Bool, diagonal: Bool) -> [String: Int] {
    var result = [String: Int]()
    for line in lines {
        if (verticalHorizontal && isOnlyVerticalOrHorizontal(line: line)) {
            let points = generatePoints(line: line)
            for point in points {
                if let val = result[point] {
                    result[point] = val + 1
                } else {
                    result[point] = 0
                }
            }
        }
        if diagonal && isDiagonal(line: line) {
            let points = generateDiagonal(line: line)
            for point in points {
                if let val = result[point] {
                    result[point] = val + 1
                } else {
                    result[point] = 0
                }
            }
        }
    }

    let intersections = result.filter { $0.value > 0 }
    return intersections
}

print("part 1: ", findIntersections(lines: lines, verticalHorizontal: true, diagonal: false).count)
print("part 2: ", findIntersections(lines: lines, verticalHorizontal: true, diagonal: true).count)
