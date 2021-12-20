//
//  main.swift
//  AOC2021_14
//
//  Created by Lubomír Kaštovský on 14.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

func getRules(lines: [String]) -> [String: String] {
    var rules = [String: String]()
    for line in lines {
        if line.contains("->") {
            let args = line.components(separatedBy: [" "])
            rules[args[0]] = args[2]
        }
    }
    return rules
}

func getPairs(lines: [String]) -> [String: Int] {
    var pairs = [String: Int]()
    let chars = Array(lines[0])
    for i in 0..<(chars.count - 1) {
        let key = String(chars[i]) + String(chars[i+1])
        if pairs[key] == nil {
            pairs[key] = 1
        } else {
            pairs[key]! += 1
        }
    }
    return pairs
}

func getOccurences(lines: [String]) -> [Character: Int] {
    var occurences = [Character: Int]()
    let chars = Array(lines[0])
    for c in chars {
        if occurences[c] == nil {
            let count = chars.filter { $0 == c }.count
            occurences[c] = count
        }
    }
    return occurences
}

let rules = getRules(lines: lines)
let pairs = getPairs(lines: lines)
let occurences = getOccurences(lines: lines)

print(rules)
print(pairs)
print(occurences)

func generate(lines: [String], steps: Int) -> Int {
    let rules = getRules(lines: lines)
    var pairs = getPairs(lines: lines)
    var occurences = getOccurences(lines: lines)

    for i in 0..<steps {
        var newPairs = [String: Int]()
        var newPairs2 = [String: Int]()
        for p in pairs.keys {
            // add occurences
            let c = rules[p]
            let key = c!.first!
            if occurences[key] == nil {
                occurences[key] = pairs[p]!
            } else {
                occurences[key]! += pairs[p]!
            }

            // add created pairs
            let repeatPair = pairs[p]!
            let newPair1 = String(p.first!) + c!
            let newPair2 = c! + String(p.last!)
            if newPairs[newPair1] == nil {
                newPairs[newPair1] = repeatPair
            } else {
                newPairs[newPair1] = newPairs[newPair1]! + repeatPair
            }
            if newPairs2[newPair2] == nil {
                newPairs2[newPair2] = repeatPair
            } else {
                newPairs2[newPair2] = newPairs2[newPair2]! + repeatPair
            }

        }
        pairs = newPairs
        for key in newPairs2.keys {
            if pairs[key] == nil {
                pairs[key] = newPairs2[key]
            } else {
                pairs[key] = pairs[key]! + newPairs2[key]!
            }
        }
    }

    //print(occurences)

    var min = Int.max
    var max = Int.min
    for key in occurences.keys {
        let oc = occurences[key]!
        if oc < min {
            min = oc
        }
        if oc > max {
            max = oc
        }
    }

    return max - min
}

let start = DispatchTime.now()
let part1 = generate(lines: lines, steps: 10)
let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

let start2 = DispatchTime.now()
let part2 = generate(lines: lines, steps: 40)
let end2 = DispatchTime.now()
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000


print("part 1: \(part1), time: \(timeInterval)")
print("part 2: \(part2), time: \(timeInterval2)")
