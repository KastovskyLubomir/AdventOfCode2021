//
//  main.swift
//  AOC2021_25
//
//  Created by Lubomír Kaštovský on 25.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

typealias Map = [[Character]]

let Empty = Character(".")
let East = Character(">")
let South = Character("v")

let lines = readLinesRemoveEmpty(str: inputString)

func loadMap(lines: [String]) -> Map {
    var result = Map()
    for line in lines {
        let chars = Array(line)
        result.append(chars)
    }
    return result
}

func oneStep(_ inputMap: Map) -> (Bool, Map) {
    var map = inputMap
    let maxRow = map.count - 1
    let maxCol = map[0].count - 1
    var changed = false
    var newMap = Map.init(repeating: [Character].init(repeating: Empty, count: maxCol+1), count: maxRow+1)
    // east first
    var row = 0
    var col = 0
    while row <= maxRow {
        col = 0
        var lastMoved = false
        while col <= maxCol {
            if map[row][col] == Empty {
                if col == 0 {
                    if map[row][maxCol] == East {
                        newMap[row][col] = East
                        newMap[row][maxCol] = Empty
                        changed = true
                        lastMoved = true
                    } else {
                        newMap[row][col] = map[row][col]
                    }
                } else {
                    if map[row][col-1] == East {
                        newMap[row][col] = East
                        newMap[row][col-1] = Empty
                        changed = true
                    } else {
                        if col == maxCol && lastMoved {
                            newMap[row][col] = Empty
                        } else {
                            newMap[row][col] = map[row][col]
                        }
                    }
                }
            } else {
                if col == maxCol && lastMoved {
                    newMap[row][col] = Empty
                } else {
                    newMap[row][col] = map[row][col]
                }
            }
            col += 1
        }
        row += 1
    }
    map = newMap
    //printMap(map)
    newMap = Map.init(repeating: [Character].init(repeating: Empty, count: maxCol+1), count: maxRow+1)
    // now south
    col = 0
    while col <= maxCol {
        var row = 0
        var lastMoved = false
        while row <= maxRow {
            if map[row][col] == Empty {
                if row == 0 {
                    if map[maxRow][col] == South {
                        newMap[row][col] = South
                        newMap[maxRow][col] = Empty
                        changed = true
                        lastMoved = true
                    } else {
                        newMap[row][col] = map[row][col]
                    }
                } else {
                    if map[row-1][col] == South {
                        newMap[row][col] = South
                        newMap[row-1][col] = Empty
                        changed = true
                    } else {
                        if row == maxRow && lastMoved {
                            newMap[row][col] = Empty
                        } else {
                            newMap[row][col] = map[row][col]
                        }
                    }
                }
            } else {
                if row == maxRow && lastMoved {
                    newMap[row][col] = Empty
                } else {
                    newMap[row][col] = map[row][col]
                }
            }
            row += 1
        }
        col += 1
    }

    return (changed, newMap)
}

func printMap(_ map: Map, step: Int? = nil) {
    if let s = step {
        print("--\(s)--")
    } else {
        print("----")
    }
    for row in map {
        print(String(row))
    }
}

func moving(map: Map) -> Int {
    var changed = true
    var step = 0
    var changingMap = map
    //printMap(changingMap)
    while changed {
        let result = oneStep(changingMap)
        if result.0 {
            changingMap = result.1
        }
        changed = result.0
        step += 1
        //printMap(changingMap, step: step)
    }
    return step
}

let map = loadMap(lines: lines)
print(moving(map: map))
