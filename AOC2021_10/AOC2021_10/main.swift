//
//  main.swift
//  AOC2021_10
//
//  Created by Lubomír Kaštovský on 11.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

func scan(line: String) -> Int {
    let openC: Set<Character> = [Character("("), Character("{"), Character("["), Character("<")]
    let closing: Set<Character> = [Character(")"), Character("}"), Character("]"), Character(">")]
    let chars = Array(line)
    var stack = [Character]()
    for i in 0..<chars.count {
        let c = chars[i]
        if openC.contains(c) {
            stack.append(c)
        } else if closing.contains(c) {
            let last = stack.last
            if c == Character(")") && last != Character("(") {
                return 3
            }
            if c == Character("]") && last != Character("[") {
                return 57
            }
            if c == Character("}") && last != Character("{") {
                return 1197
            }
            if c == Character(">") && last != Character("<") {
                return 25137
            }
            stack.removeLast()
        }
    }
    return -1
}

//print(scan(line: "{([(<{}[<>[]}>{[]{[(<()>"))
//print(scan(line: "<{([([[(<>()){}]>(<<{{"))

func scanLines(lines: [String]) -> Int {
    var sum = 0
    for line in lines {
        let res = scan(line: line)
        if res > 0 {
            sum += res
        }
    }
    return sum
}

func keepIncomplete(lines: [String]) -> [String] {
    var result = [String]()
    for line in lines {
        let res = scan(line: line)
        if res < 0 {
            result.append(line)
        }
    }
    return result
}

func completion(line: String) -> Int {
    let openC: Set<Character> = [Character("("), Character("{"), Character("["), Character("<")]
    let closing: Set<Character> = [Character(")"), Character("}"), Character("]"), Character(">")]
    let chars = Array(line)
    var stack = [Character]()
    for i in 0..<chars.count {
        let c = chars[i]
        if openC.contains(c) {
            stack.append(c)
        } else if closing.contains(c) {
            let last = stack.last
            stack.removeLast()
        }
    }
    var score = 0
    while !stack.isEmpty {
        let last = stack.last
        if last == Character("(") {
            score = (score * 5) + 1
        } else if last == Character("[") {
            score = (score * 5) + 2
        } else if last == Character("{") {
            score = (score * 5) + 3
        } else if last == Character("<") {
            score = (score * 5) + 4
        }
        stack.removeLast()
    }
    return score
}

let incomplete = keepIncomplete(lines: lines)

func middleScore(incomplete: [String]) -> Int {
    var scores = [Int]()
    for line in incomplete {
        scores.append(completion(line: line))
    }

    let sorted = scores.sorted()
    //print(sorted.count)
    //print(sorted)
    return sorted[sorted.count/2]
}

print("part 1: ", scanLines(lines: lines))
print("part 2: ", middleScore(incomplete: incomplete))
