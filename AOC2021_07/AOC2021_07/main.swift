//
//  main.swift
//  AOC2021_07
//
//  Created by Lubomír Kaštovský on 11.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

let positions = stringNumArrayToArrayOfInt(input: lines[0], separators: [","])
//print(positions)

func bestPositionFuel(positions: [Int]) -> Int {
    let min = positions.min()!
    let max = positions.max()!

    var bestDiffSum = Int.max
    for pos in min...max {
        var diffSum = 0
        for crabPos in positions {
            diffSum += abs(pos - crabPos)
        }
        if diffSum < bestDiffSum {
            bestDiffSum = diffSum
        }
    }
    return bestDiffSum
}

func bestPositionFuel2(positions: [Int]) -> Int {
    let min = positions.min()!
    let max = positions.max()!

    var bestDiffSum = Int.max
    for pos in min...max {
        var diffSum = 0
        for crabPos in positions {
            let diff = abs(pos - crabPos)
            diffSum += ((diff+1) * diff)/2
        }
        if diffSum < bestDiffSum {
            bestDiffSum = diffSum
        }
    }
    return bestDiffSum
}

print("part 1: ", bestPositionFuel(positions: positions))
print("part 2: ", bestPositionFuel2(positions: positions))
