//
//  main.swift
//  AOC2021_06
//
//  Created by Lubomír Kaštovský on 08.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

class Fish:Equatable {
    var offset: Int = 0
    var day: Int = 0
    static func == (lhs: Fish, rhs: Fish) -> Bool {
        return lhs.offset == rhs.offset && lhs.day == rhs.day
    }
    init(offset: Int = 0, day: Int = 0) {
        self.offset = offset
        self.day = day
    }
}


let numbers = stringNumArrayToArrayOfInt(input: inputString, separators: [",","\n"])
//print(numbers)


func children(fish: Fish, days: Int) -> [Fish] {
    var i = fish.day + fish.offset + 1
    var result = [Fish]()
    while i <= days {
        result.append(Fish(offset: 8, day: i))
        i += 7
    }
    return result
}

//print(children(fish: Fish(offset: 3, day: 1), days: 18))

func generateFish(startingFish: [Fish], days: Int) -> [Fish] {
    var allFish = startingFish
    var i = 0
    while i < allFish.count {
        let children = children(fish: allFish[i], days: days)
        allFish += children
        i += 1
/*
        var str = String(i) + ". "
        for f in allFish {
            str += String(f.offset)
        }
        print(str)
*/
    }
    return allFish
}

func children2(fish: Fish, days: Int) -> LinkedList<Fish> {
    var i = fish.day + fish.offset + 1
    let result = LinkedList<Fish>()
    while i <= days {
        result.appendLast(value: Fish(offset: 8, day: i))
        i += 7
    }
    return result
}


func generateFish2(startingFish: [Fish], days: Int) -> Int {
    let allFish = LinkedList<Fish>()
    var count = 0
    for f in startingFish {
        allFish.appendLast(value: f)
    }
    while allFish.count > 0 {
        let children = children2(fish: allFish.first!.value!, days: days)
        allFish.appendList(other: children)
        allFish.removeFirst()
        count += 1
    }
    return count
}

// 3,4,3,1,2
/*
let fishes = [
    Fish(offset: 3, day: 0), Fish(offset: 4, day: 0), Fish(offset: 3, day: 0),
    Fish(offset: 1, day: 0), Fish(offset: 2, day: 0)
]
let result = generateFish(startingFish: fishes, days: 80)
print(result.count)
*/

func numbersToFish(numbers: [Int]) -> [Fish] {
    var result = [Fish]()
    for x in numbers {
        result.append(Fish(offset: x, day: 0))
    }
    return result
}

func countChildren(offset: Int, day: Int, days: Int) -> Int {
    var i = day + offset + 1
    var result = 0
    while i <= days {
        result += countChildren(offset: 8, day: i, days: days)
        i += 7
    }
    return result + 1
}

func smart(numbers: [Int], days: Int) -> Int {
    var sum = 0
    for n in numbers {
        sum += countChildren(offset: n, day: 0, days: days)
    }
    return sum
}

/*
let fish = numbersToFish(numbers: numbers)
let generated = generateFish2(startingFish: fish, days: 80)
print(generated)
*/

/*
let generated2 = generateFish2(startingFish: fish, days: 256)
print(generated2)
*/
//print(generateFish2(startingFish: fishes, days: 80))

print(smart(numbers: [3,4,3,1,2], days: 18))
print(smart(numbers: [3,4,3,1,2], days: 80))
print(smart(numbers: numbers, days: 80))
//print(smart(numbers: numbers, days: 256))


func evenSmarter(numbers: [Int], days: Int) -> Int {

    var age = [Int].init(repeating: 0, count: 9)
    for n in numbers {
        age[n] += 1
    }

    var tmp = 0
    for _ in 0..<days {
        tmp = age[0]
        age[0] = age[1]
        age[1] = age[2]
        age[2] = age[3]
        age[3] = age[4]
        age[4] = age[5]
        age[5] = age[6]
        age[6] = age[7] + tmp
        age[7] = age[8]
        age[8] = tmp
        //print(age)
    }
    return age.reduce(0, +)
}

print(evenSmarter(numbers: [3,4,3,1,2], days: 80))
print(evenSmarter(numbers: numbers, days: 80))
print(evenSmarter(numbers: numbers, days: 256))
