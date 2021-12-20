//
//  main.swift
//  AOC2021_02
//
//  Created by Lubomír Kaštovský on 06.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

func distance(commands: [String]) -> Int {

    var horizontal = 0
    var depth = 0
    for command in commands {
        let args = stringWordArrayToArrayOfWords(input: command, separators: [" "])
        let distance = Int(args[1])
        if "forward" == args[0] {
            horizontal += distance!
        }
        if "down" == args[0] {
            depth += distance!
        }
        if "up" == args[0] {
            depth -= distance!
        }
    }

    return horizontal * depth
}


func distanceWithAim(commands: [String]) -> Int {

    var horizontal = 0
    var depth = 0
    var aim = 0
    for command in commands {
        let args = stringWordArrayToArrayOfWords(input: command, separators: [" "])
        let distance = Int(args[1])
        if "forward" == args[0] {
            horizontal += distance!
            depth += aim * distance!
        }
        if "down" == args[0] {
            aim += distance!
        }
        if "up" == args[0] {
            aim -= distance!
        }
    }

    return horizontal * depth
}

print("part 1:", distance(commands: lines))
print("part 2:", distanceWithAim(commands: lines))
