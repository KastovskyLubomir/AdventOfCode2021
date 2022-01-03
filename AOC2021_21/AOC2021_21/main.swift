//
//  main.swift
//  AOC2021_21
//
//  Created by Lubomír Kaštovský on 21.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

/*
 Player 1 starting position: 9
 Player 2 starting position: 3
 */

func rollDie(die: Int) -> (sum: Int, die: Int) {
    var sum = 0
    var dd = die
    for i in 0..<3 {
        sum += dd
        dd += 1
        if dd == 101 {
            dd = 1
        }
    }
    return (sum, dd)
}

func play() {
    var player1Score = 0
    var player2Score = 0

    var player1Position = 9
    var player2Position = 3

    var die = 1
    var rolled = 0

    while player1Score < 1000 && player2Score < 1000 {
        let roll = rollDie(die: die)
        die = roll.die
        player1Position = ((player1Position + roll.sum - 1) % 10) + 1
        player1Score += player1Position
        rolled += 3
        if player1Score >= 1000 {
            break
        }
        let roll2 = rollDie(die: die)
        die = roll2.die
        player2Position = ((player2Position + roll2.sum - 1) % 10) + 1
        player2Score += player2Position
        rolled += 3
    }
    if player1Score > player2Score {
        print("1: \(player1Score), \(rolled)")
        print("2: \(player2Score), \(rolled)")
        print(rolled * player2Score)
    } else {
        print("1: \(player1Score), \(rolled)")
        print("2: \(player2Score), \(rolled)")
        print(rolled * player1Score)
    }
}

// roll sum : occurence
func dieVariants() -> [Int: Int] {
    var result = [Int: Int]()
    for i in 1...3 {
        for j in 1...3 {
            for k in 1...3 {
                let key = i + j + k
                if result[key] == nil {
                    result[key] = 1
                } else {
                    result[key] = result[key]! + 1
                }
            }
        }
    }
    return result
}

func sumWinSpaces(pos1: Int, score1: Int, pos2: Int, score2: Int, turn: Int, spaces: Int, variants: [Int: Int]) -> (Int, Int) {
    if score1 >= 21 {
        return (spaces, 0)
    }
    if score2 >= 21 {
        return (0, spaces)
    }
    if turn == 1 {
        var spaces1 = 0
        var spaces2 = 0
        for v in variants {
            let newPos1 = ((pos1 + v.key - 1) % 10) + 1
            let newScore1 = score1 + newPos1
            let newSpaces = spaces == 0 ? v.value : spaces * v.value
            let res = sumWinSpaces(pos1: newPos1, score1: newScore1, pos2: pos2, score2: score2, turn: 2, spaces: newSpaces, variants: variants)
            spaces1 += res.0
            spaces2 += res.1
        }
        return (spaces1, spaces2)
    } else {
        var spaces1 = 0
        var spaces2 = 0
        for v in variants {
            let newPos2 = ((pos2 + v.key - 1) % 10) + 1
            let newScore2 = score2 + newPos2
            let newSpaces = spaces == 0 ? v.value : spaces * v.value
            let res = sumWinSpaces(pos1: pos1, score1: score1, pos2: newPos2, score2: newScore2, turn: 1, spaces: newSpaces, variants: variants)
            spaces1 += res.0
            spaces2 += res.1
        }
        return (spaces1, spaces2)
    }
}

// part 1
play()

// part 2
let variants = dieVariants()
let result = sumWinSpaces(pos1: 9, score1: 0, pos2: 3, score2: 0, turn: 1, spaces: 0, variants: variants)
print("score 1: \(result.0)")
print("score 2: \(result.1)")
