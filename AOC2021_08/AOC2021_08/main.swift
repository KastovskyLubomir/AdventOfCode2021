//
//  main.swift
//  AOC2021_08
//
//  Created by Lubomír Kaštovský on 11.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

func countNumbers(lines: [String]) -> Int {
    var count = 0
    for line in lines {
        let args = line.components(separatedBy: [" "])
        for i in (args.count - 5)..<args.count {
            if args[i].count == 2 || args[i].count == 3 || args[i].count == 4 || args[i].count == 7 {
                count += 1
            }
        }
    }
    return count
}

func decodeSignals(lines: [String]) -> Int {
    var result = 0
    for line in lines {
        var numbers = [String].init(repeating: "", count: 10)
        let parts = line.components(separatedBy: ["|"])
        var args = parts[0].components(separatedBy: [" "])
        args.removeLast()
        // 1
        numbers[1] = args.first(where: { $0.count == 2 })!
        // 4
        numbers[4] = args.first(where: { $0.count == 4 })!
        // 7
        numbers[7] = args.first(where: { $0.count == 3 })!
        // 8
        numbers[8] = args.first(where: { $0.count == 7 })!

        //2,3,5
        let fiveChars = args.filter { $0.count == 5 }
        // 3
        numbers[3] = fiveChars.first { $0.contains(Array(numbers[1])[0]) && $0.contains(Array(numbers[1])[1]) }!
        // 2,5
        let twoAndFive = fiveChars.filter { $0 != numbers[3] }
        // 0,6,9
        let sixChars = args.filter { $0.count == 6 }
        // 0,9
        let zeroAndNine = sixChars.filter { $0.contains(Array(numbers[1])[0]) && $0.contains(Array(numbers[1])[1]) }
        numbers[6] = sixChars.first { !zeroAndNine.contains($0) }!
        // 9
        numbers[9] = zeroAndNine.first {
            $0.contains(Array(numbers[3])[0]) &&
            $0.contains(Array(numbers[3])[1]) &&
            $0.contains(Array(numbers[3])[2]) &&
            $0.contains(Array(numbers[3])[3]) &&
            $0.contains(Array(numbers[3])[4])
        }!
        // 0
        numbers[0] = zeroAndNine.first { $0 != numbers[9] }!
        // segment from 4 which is not in 3, must be in 5
        let chars4 = Array(numbers[4])
        let chars3 = Array(numbers[3])
        let segment = chars4.first { !chars3.contains($0)}!
        // 5
        numbers[5] = twoAndFive.first { $0.contains(segment)}!
        // 2
        numbers[2] = twoAndFive.first { $0 != numbers[5] }!

        //print(numbers)

        // digits
        var digits = parts[1].components(separatedBy: [" "])
        digits.removeFirst()
        var digitVal = 0
        for digit in digits {
            let dig = digit.sorted()
            let signal = numbers.first { $0.sorted() == dig }!
            let val = numbers.firstIndex(of: signal)!
            digitVal = digitVal * 10 + val
        }
        result += digitVal
    }
    return result
}

print("part 1: ", countNumbers(lines: lines))

let test = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]

//print(decodeSignals(lines: test))

print("part 2: ", decodeSignals(lines: lines))
