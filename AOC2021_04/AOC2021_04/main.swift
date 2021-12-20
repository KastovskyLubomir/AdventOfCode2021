//
//  main.swift
//  AOC2021_04
//
//  Created by Lubomír Kaštovský on 06.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct BoardNumber {
    let value: Int
    var marked: Bool
}

typealias Board = [[BoardNumber]]

let input = readLinesRemoveEmpty(str: inputString)

func readNumbers(lines: [String]) -> [Int] {
    return stringNumArrayToArrayOfInt(input: lines[0], separators: [","])
}

func readBoards(lines: [String]) -> [Board] {
    var lns = lines
    lns.removeFirst()
    var boards = [Board]()
    var board = Board()
    for i in 0..<lns.count {
        if (i % 5) == 0 && i > 0 {
            boards.append(board)
            board = Board()
        }
        let row = stringNumArrayToArrayOfInt(input: lns[i], separators: [" "]).map { BoardNumber(value: $0, marked: false)}
        board.append(row)
    }
    boards.append(board)
    return boards
}

func markNumber(value: Int, board: inout Board) {
    var i = 0
    for row in board {
        var j = 0
        for number in row {
            if number.value == value {
                board[i][j].marked = true
            }
            j += 1
        }
        i += 1
    }
}

func checkRow(index: Int, board: Board) -> Bool {
    for x in board[index] {
        if !x.marked {
            return false
        }
    }
    return true
}

func checkColumn(index: Int, board: Board) -> Bool {
    for row in board {
        if !row[index].marked {
            return false
        }
    }
    return true
}

func checkWinner(board: Board) -> Bool {
    for i in 0..<5 {
        if checkRow(index: i, board: board) || checkColumn(index: i, board: board) {
            return true
        }
    }
    return false
}

func sumUnmarked(board: Board) -> Int {
    var sum = 0
    for row in board {
        for x in row {
            if !x.marked {
                sum += x.value
            }
        }
    }
    return sum
}

func playBingo(input: [String]) -> Int {
    let numbers = readNumbers(lines: input)
    var boards = readBoards(lines: input)
    for number in numbers {
        var i = 0
        for _ in boards {
            markNumber(value: number, board: &boards[i])
            i += 1
        }
        for board in boards {
            if checkWinner(board: board) {
                return sumUnmarked(board: board) * number
            }
        }
    }
    return 0
}

func playBingoLastWinning(input: [String]) -> Int {
    let numbers = readNumbers(lines: input)
    var boards = readBoards(lines: input)
    for number in numbers {
        var i = 0
        for _ in boards {
            markNumber(value: number, board: &boards[i])
            i += 1
        }
        var newBoards = [Board]()
        for board in boards {
            if !checkWinner(board: board) {
                newBoards.append(board)
            } else if boards.count == 1 {
                return sumUnmarked(board: boards[0]) * number
            }
        }
        boards = newBoards
    }
    return 0
}

print("part 1: ", playBingo(input: input))
print("part 2: ", playBingoLastWinning(input: input))
