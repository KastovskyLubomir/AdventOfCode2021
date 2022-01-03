//
//  main.swift
//  AOC2021_23
//
//  Created by Lubomír Kaštovský on 23.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation


/**
 #############
 #...........#
 ###C#A#B#C###
      #D#D#B#A#
      #########
 */

/*
 #############
 #...........#
 ###C#A#B#C###
   #D#C#B#A#
   #D#B#A#C#
   #D#D#B#A#
   #########
 */


extension String {
    func split(every length:Int) -> [Substring] {
        guard length > 0 && length < count else { return [suffix(from:startIndex)] }
        return (0 ... (count - 1) / length).map { dropFirst($0 * length).prefix(length) }
    }
}

let lines =         "...........##C#A#B#C####D#D#B#A##"
let lines2 =        "...........##C#A#B#C####D#C#B#A####D#B#A#C####D#D#B#A##"
let linesTest =     "...........##B#C#B#D####D#C#B#A####D#B#A#C####A#D#C#A##"
let linesTest2 =    "...........##B#C#B#D####A#D#C#A##"
let hallPositions = [0,1,3,5,7,9,10]
let roomX = [Character("A") : 2, Character("B") : 4, Character("C") : 6, Character("D") : 8]
let amfidNames = [Character("A"), Character("B"), Character("C"), Character("D")]
let amfidEnergy = [Character("A") : 1, Character("B") : 10, Character("C") : 100, Character("D") : 1000]

func amfids(map: Array<Array<Character>>) -> [(x: Int, y:Int, name: Character)] {
    var result = [(x: Int, y:Int, name: Character)]()
    for row in 0..<map.count {
        for col in 0..<map[row].count {
            if amfidNames.contains(map[row][col]) {
                result.append((x:col, y:row, name: map[row][col]))
            }
        }
    }
    return result
}

func canGoToHall(destX: Int, posx: Int, posy: Int, map: inout Array<Array<Character>>) -> (Bool, Int) {
    guard map[0][destX] == Character(".") else {
        return (false, 0)
    }
    var energy = 0
    var y = posy
    var x = posx
    while y > 0 {
        y = y - 1
        if map[y][x] == Character(".") {
            energy += 1
        } else {
            return (false, 0)
        }
    }
    let addition = x > destX ? -1 : 1
    while x != destX {
        x += addition
        if map[y][x] == Character(".") {
            energy += 1
        } else {
            return (false, 0)
        }
    }
    return (true, energy)
}

func canGoToRoom(destX: Int, destY: Int, posx: Int, posy: Int, map: inout Array<Array<Character>>) -> (Bool, Int) {
    guard map[destY][destX] == Character(".") else {
        return (false, 0)
    }
    var energy = 0
    var y = posy
    var x = posx
    let addition = x > destX ? -1 : 1
    while x != destX {
        x += addition
        if map[y][x] == Character(".") {
            energy += 1
        } else {
            return (false, 0)
        }
    }
    while y != destY {
        y = y + 1
        if map[y][x] == Character(".") {
            energy += 1
        } else {
            return (false, 0)
        }
    }
    return (true, energy)
}

func isHome(amfid: (x: Int, y:Int, name: Character), lines: inout Array<Array<Character>>) -> Bool {
    if amfid.x == roomX[amfid.name]! {
        var yy = amfid.y
        while yy < lines.count {
            if lines[yy][amfid.x] == amfid.name {
                yy += 1
            } else {
                return false
            }
        }
        return true
    }
    return false
}

func availableRoom(name: Character, lines: inout Array<Array<Character>>) -> Int {
    let x = roomX[name]!
    var y = 1
    while y < lines.count {
        if lines[y][x] == "." {
            y += 1
        } else if lines[y][x] == name {
            for yy in y..<lines.count {
                if lines[yy][x] != name {
                    return -1
                }
            }
            return y - 1
        } else {
            return -1
        }
    }
    return y - 1
}

func steps(map: (String, Int)) -> [(String, Int)] {
    var result = [(String, Int)]()
    var lines = map.0.split(every: 11).map { Array(String($0)) }
    //print(lines)
    let amfids = amfids(map: lines)
    //print(amfids)
    for amfid in amfids {
        if amfid.y != 0 {
            // is in room
            //if (amfid.x == roomX[amfid.name]! && amfid.y == 2) || amfid.x == roomX[amfid.name]! && amfid.y == 1 && lines[2][amfid.x] == amfid.name {
            if isHome(amfid: amfid, lines: &lines) {
                // it is home, can't move
                continue
            }
            for pos in hallPositions {
                let res = canGoToHall(destX: pos, posx: amfid.x, posy: amfid.y, map: &lines)
                if res.0 {
                    var newLines = lines
                    newLines[0][pos] = amfid.name
                    newLines[amfid.y][amfid.x] = Character(".")
                    result.append((newLines.map { String($0) }.joined(), map.1 + res.1*amfidEnergy[amfid.name]!))
                }
            }
        } else {
            // is in hall
/*
            let destX = roomX[amfid.name]!
            if lines[1][destX] == Character(".") && lines[2][destX] == amfid.name {
                let res = canGoToRoom(destX: destX, destY: 1, posx: amfid.x, posy: amfid.y, map: &lines)
                if res.0 {
                    var newLines = lines
                    newLines[1][destX] = amfid.name
                    newLines[amfid.y][amfid.x] = Character(".")
                    result.append((newLines.map { String($0) }.joined(), map.1 + res.1*amfidEnergy[amfid.name]!))
                }
            } else if lines[1][destX] == Character(".") && lines[2][destX] == Character(".") {
                let res = canGoToRoom(destX: destX, destY: 2, posx: amfid.x, posy: amfid.y, map: &lines)
                if res.0 {
                    var newLines = lines
                    newLines[2][destX] = amfid.name
                    newLines[amfid.y][amfid.x] = Character(".")
                    result.append((newLines.map { String($0) }.joined(), map.1 + res.1*amfidEnergy[amfid.name]!))
                }
            }
*/

            let availY = availableRoom(name: amfid.name, lines: &lines)
            if availY > 0 {
                let destX = roomX[amfid.name]!
                let res = canGoToRoom(destX: destX, destY: availY, posx: amfid.x, posy: amfid.y, map: &lines)
                if res.0 {
                    var newLines = lines
                    newLines[availY][destX] = amfid.name
                    newLines[amfid.y][amfid.x] = Character(".")
                    result.append((newLines.map { String($0) }.joined(), map.1 + res.1*amfidEnergy[amfid.name]!))
                }
            }


        }
    }
    return result
}

func found(map: String) -> Bool {
    let lines = Array(map)
    for i in 1...(lines.count/11)-1 {
        if !(lines[i*11+2] == Character("A") && lines[i*11+4] == Character("B") && lines[i*11+6] == Character("C") && lines[i*11+8] == Character("D")) {
            return false
        }
    }
    return true
}

struct CheckedState: Hashable {
    let state: String
    let energy: Int

    static func == (lhs: CheckedState, rhs: CheckedState) -> Bool {
        return lhs.state == rhs.state
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(state)
    }
}

func search(map: [(String, Int)], minFound: Int, checked: inout Set<CheckedState>) -> (String, Int) {
    //print(checked.count)
    //print(map.count)

    if found(map: map.last!.0) {
        print(map.last!.1)
        printMap(map: map.last!.0)
        return map.last!
    }
    var resultState = ""
    var minEnergy = minFound
    let generated = steps(map: map.last!)
    for gen in generated {
        let checkedState = CheckedState(state: gen.0, energy: gen.1)
        if let ccc = checked.first(where: { $0 == checkedState }) {
            if ccc.energy > checkedState.energy {
                checked.remove(ccc)
                checked.insert(checkedState)
            } else {
                continue
            }
        } else {
            checked.insert(checkedState)
        }
        let containsGen = map.contains(where: { $0.0 == gen.0 })
        //print("\(gen.1), \(minEnergy)")
        if !containsGen && (gen.1 < minEnergy) {
            //printMap(map: gen.0)
            //print("\(gen.1), \(minEnergy)")
            //printMap(map: gen.0)
            let result = search(map: map + [gen], minFound: minEnergy, checked: &checked )
            if !result.0.isEmpty {
                if result.1 < minEnergy {
                    resultState = result.0
                    minEnergy = result.1
                }
            }
        }
    }
    return (resultState, minEnergy)
}

func printMap(map: String) {
    var lines = map.split(every: 11).map { String($0) }
    lines.forEach {
        print($0)
    }
    print("")
}

//print(lines.split(every: 11).map { String($0) })

//let stepsGenerated = steps(map: (lines, 0))
//print(stepsGenerated)
var checked: Set<CheckedState> = []
//print(search(map: [(lines, 0)], minFound: Int.max, checked: &checked))

//printMap(map: lines2)
let start = DispatchTime.now()
let result = search(map: [(lines2, 0)], minFound: Int.max, checked: &checked)
let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

print("\(result)\n time: \(timeInterval)")

