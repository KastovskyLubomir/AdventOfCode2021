//
//  main.swift
//  AOC2021_09
//
//  Created by Lubomír Kaštovský on 11.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

typealias HeightMap = [[Int]]

let lines = readLinesRemoveEmpty(str: inputString)

func createMap(lines: [String]) -> HeightMap {
    var result = HeightMap()
    for line in lines {
        let characters = Array(line)
        let numbers = characters.map { Int(String($0))! }
        result.append(numbers)
    }
    return result
}

func isLowest(row: Int, col: Int, heightMap: inout HeightMap) -> Bool {
    let height = heightMap[row][col]
    if row > 0 {
        if heightMap[row-1][col] <= height {
            return false
        }
    }
    if row < heightMap.count - 1 {
        if heightMap[row+1][col] <= height {
            return false
        }
    }
    if col > 0 {
        if heightMap[row][col-1] <= height {
            return false
        }
    }
    if col < heightMap[row].count - 1 {
        if heightMap[row][col+1] <= height {
            return false
        }
    }
    return true
}

typealias Point = (row: Int, col: Int)

func basinSize(r: Int, c: Int, heightMap: inout HeightMap) -> Int {
    var toCheck = [Point(r, c)]
    var checked = [Point]()
    var row = 0
    var col = 0
    while !toCheck.isEmpty {
        let point = toCheck.first!
        toCheck.removeFirst()
        checked.append(point)
        row = point.row
        col = point.col
        if row > 0 {
            if heightMap[row-1][col] != 9 {
                if !checked.contains(where: { $0.row == row-1 && $0.col == col }) &&
                    !toCheck.contains(where: { $0.row == row-1 && $0.col == col }) {
                    toCheck.append(Point(row-1, col))
                }
            }
        }
        if row < heightMap.count - 1 {
            if heightMap[row+1][col] != 9 {
                if !checked.contains(where: { $0.row == row+1 && $0.col == col }) &&
                    !toCheck.contains(where: { $0.row == row+1 && $0.col == col }) {
                    toCheck.append(Point(row+1, col))
                }
            }
        }
        if col > 0 {
            if heightMap[row][col-1] != 9 {
                if !checked.contains(where: { $0.row == row && $0.col == col-1 }) &&
                    !toCheck.contains(where: { $0.row == row && $0.col == col-1 }) {
                    toCheck.append(Point(row, col-1))
                }
            }
        }
        if col < heightMap[row].count - 1 {
            if heightMap[row][col+1] != 9 {
                if !checked.contains(where: { $0.row == row && $0.col == col+1 }) &&
                    !toCheck.contains(where: { $0.row == row && $0.col == col+1 }){
                    toCheck.append(Point(row, col+1))
                }
            }
        }
    }
    return checked.count
}

func lowPointsRiskSum(heightMap: inout HeightMap) -> Int {
    var riskSum = 0
    for row in 0..<heightMap.count {
        for col in 0..<heightMap[row].count {
            if isLowest(row: row, col: col, heightMap: &heightMap) {
                riskSum += heightMap[row][col] + 1
            }
        }
    }
    return riskSum
}

func getBasinSizes(heightMap: inout HeightMap) -> [Int] {
    var sizes = [Int]()
    for row in 0..<heightMap.count {
        for col in 0..<heightMap[row].count {
            if isLowest(row: row, col: col, heightMap: &heightMap) {
                sizes.append(basinSize(r: row, c: col, heightMap: &heightMap))
            }
        }
    }
    return sizes.sorted()
}

var heightMap = createMap(lines: lines)

print("part 1: ", lowPointsRiskSum(heightMap: &heightMap))

let sizes = getBasinSizes(heightMap: &heightMap)
print("part 2: ", sizes[sizes.count - 1] * sizes[sizes.count - 2] * sizes[sizes.count - 3])
