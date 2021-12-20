//
//  main.swift
//  AOC2021_13
//
//  Created by Lubomír Kaštovský on 13.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int
}

struct Fold {
    let axis: String
    let val: Int
}

let lines = readLinesRemoveEmpty(str: inputString)

let pointsStr = lines.filter { !$0.contains("fold") }
let foldsStr = lines.filter { $0.contains("fold") }

let points: [Point] = pointsStr.map {
    let args = $0.components(separatedBy: [","])
    return Point(x: Int(args[0])!, y: Int(args[1])!)
}

let folds: [Fold] = foldsStr.map {
    let args = $0.components(separatedBy: [" ", "="])
    return Fold(axis: args[2], val: Int(args[3])!)
}

//print(points)
//print(folds)

func folding(points: [Point], folds: [Fold]) -> [Point] {
    var dots = points
    for fold in folds {
        if fold.axis == "x" {
            for i in 0..<dots.count {
                if dots[i].x > fold.val {
                    dots[i].x = fold.val - (dots[i].x - fold.val)
                }
            }
            dots = Array(Set(dots))
        }
        if fold.axis == "y" {
            for i in 0..<dots.count {
                if dots[i].y > fold.val {
                    dots[i].y = fold.val - (dots[i].y - fold.val)
                }
            }
            dots = Array(Set(dots))
        }
    }
    return dots
}

print("part 1: ", folding(points: points, folds: [folds[0]]).count)

let code = folding(points: points, folds: folds)

func printCode(code: [Point]) {
    var minX = Int.max
    var minY = Int.max
    var maxX = Int.min
    var maxY = Int.min
    for point in code {
        if point.x > maxX {
            maxX = point.x
        }
        if point.y > maxY {
            maxY = point.y
        }
        if point.x < minX {
            minX = point.x
        }
        if point.y < minY {
            minY = point.y
        }
    }
    //var paper = [String]
    for y in minY...maxY {
        var line = ""
        for x in minX...maxX {
            let point = Point(x: x, y: y)
            if code.contains(point) {
                line += String(UnicodeScalar(UInt8(35)))
            } else {
                line += " "
            }
        }
        print(line)
    }

}

print("part 2:")
printCode(code: code)
