//
//  main.swift
//  AOC2021_11
//
//  Created by Lubomír Kaštovský on 11.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct Octo {
    var energy: Int
    var flashed: Bool
}

let lines = readLinesRemoveEmpty(str: inputString)

func createBoard(lines: [String]) -> [[Octo]] {
    var board = [[Octo]]()
    for line in lines {
        var row = [Octo]()
        for c in Array(line) {
            row.append(Octo(energy: Int(String(c))!, flashed: false))
        }
        board.append(row)
    }
    return board
}

let inputBoard = createBoard(lines: lines)

func printBoard(board: [[Octo]]) {
    for row in 0..<board.count {
        var str = "-"
        for col in 0..<board[row].count {
            str += String(board[row][col].energy)
        }
        str += "-"
        print(str)
    }
    print("")
}

func increaseEnergy(board: inout [[Octo]]) {
    for row in 0..<board.count {
        for col in 0..<board[row].count {
            board[row][col].energy += 1
        }
    }
}

func increaseNeighbours(board: inout [[Octo]]) {
    var row = 0
    while row < board.count {
        var col = 0
        while col < board[row].count {
            if board[row][col].energy > 9 && !board[row][col].flashed {
                let lastCol = board[row].count - 1
                let lastRow = board.count - 1
                if row > 0 {
                    if col > 0 {
                        board[row-1][col-1].energy += 1
                    }
                    board[row-1][col].energy += 1
                    if col < lastCol {
                        board[row-1][col+1].energy += 1
                    }
                }
                if col > 0 {
                    board[row][col-1].energy += 1
                }
                if col < lastCol {
                    board[row][col+1].energy += 1
                }
                if row < lastRow {
                    if col > 0 {
                        board[row+1][col-1].energy += 1
                    }
                    board[row+1][col].energy += 1
                    if col < lastCol {
                        board[row+1][col+1].energy += 1
                    }
                }
                board[row][col].flashed = true
                row = -1
                break
            }
            col += 1
        }
        row += 1
    }
}

func turnOffFlashed(board: inout [[Octo]]) {
    for row in 0..<board.count {
        for col in 0..<board[row].count {
            if board[row][col].flashed {
                board[row][col].energy = 0
                board[row][col].flashed = false
            }
        }
    }
}

func flashing(octopuses: [[Octo]], steps: Int) -> Int {
    var board = octopuses
    var flashed = 0
    for step in 0..<steps {
        increaseEnergy(board: &board)
        increaseNeighbours(board: &board)
        flashed += board.flatMap { $0 }.filter { $0.flashed }.count
        turnOffFlashed(board: &board)
    }
    return flashed
}

func flashing2(octopuses: [[Octo]]) -> Int {
    var board = octopuses
    var step = 1
    while true {
        increaseEnergy(board: &board)
        increaseNeighbours(board: &board)
        if board.flatMap { $0 }.filter({ $0.flashed }).count == 100 {
            break
        }
        turnOffFlashed(board: &board)
        step += 1
    }
    return step
}

print("part 1: ", flashing(octopuses: inputBoard, steps: 100))
print("part 2: ", flashing2(octopuses: inputBoard))
