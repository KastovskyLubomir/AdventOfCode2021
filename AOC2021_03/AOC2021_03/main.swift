//
//  main.swift
//  AOC2021_03
//
//  Created by Lubomír Kaštovský on 06.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

func getStringCharacters(str:String) -> Array<Character> {
    let buf1 = [Character](str)
    return buf1
}

let lines = readLinesRemoveEmpty(str: inputString)
let zero = Character("0")
let one = Character("1")

func consumption(data: [String]) -> Int {
    var flags = [Int].init(repeating: 0, count: data[0].count)
    for bin in data {
        let chars = getStringCharacters(str: bin)
        var i = 0
        for x in chars {
            flags[i] = (x == zero) ? flags[i] - 1 : flags[i] + 1
            i += 1
        }
    }
    print(flags)
    var gammaRate = 0
    var epsilonRate = 0
    for flag in flags {
        // zeros
        if flag < 0 {
            gammaRate = gammaRate << 1
            epsilonRate = (epsilonRate << 1) + 1
        }
        //ones
        if flag > 0 {
            gammaRate = (gammaRate << 1) + 1
            epsilonRate = epsilonRate << 1
        }
        // should not happed :-)
        if flag == 0 {

        }
    }
    return gammaRate * epsilonRate
}

func oxygenGeneratorO2(data: [String]) -> Int {
    let len = data[0].count
    var oxygen = data
    var i = 0
    repeat {
        var mostCommon = 0
        for bin in oxygen {
            let chars = getStringCharacters(str: bin)
            mostCommon = (chars[i] == zero) ? mostCommon - 1 : mostCommon + 1
        }
        var keep = Character("0")
        if mostCommon >= 0 {
            keep = Character("1")
        }
        var newOxygen = [String]()
        for bin in oxygen {
            let chars = getStringCharacters(str: bin)
            if chars[i] == keep {
                newOxygen.append(bin)
            }
        }
        oxygen = newOxygen
        i += 1
    } while (oxygen.count > 1) && (i < len)
    print(oxygen)
    let number = Int(oxygen[0], radix: 2)
    print(number)
    return number!
}

func CO2Scrubber(data: [String]) -> Int {
    let len = data[0].count
    var co2 = data
    var i = 0
    repeat {
        var mostCommon = 0
        for bin in co2 {
            let chars = getStringCharacters(str: bin)
            mostCommon = (chars[i] == zero) ? mostCommon - 1 : mostCommon + 1
        }
        var keep = Character("1")
        if mostCommon >= 0 {
            keep = Character("0")
        }
        var newCO2 = [String]()
        for bin in co2 {
            let chars = getStringCharacters(str: bin)
            if chars[i] == keep {
                newCO2.append(bin)
            }
        }
        co2 = newCO2
        i += 1
    } while (co2.count > 1) && (i < len)
    print(co2)
    let number = Int(co2[0], radix: 2)
    print(number)
    return number!
}

print("part 1: ", consumption(data: lines))

let oxygen = oxygenGeneratorO2(data: lines)
let co2 = CO2Scrubber(data: lines)

print("part 2: ", oxygen * co2)
