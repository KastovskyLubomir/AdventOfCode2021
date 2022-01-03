//
//  main.swift
//  AOC2021_24
//
//  Created by Lubomír Kaštovský on 24.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

func loadProgram(lines: [String]) -> [[String]] {
    var result = [[String]]()
    for line in lines {
        let args = line.components(separatedBy: " ")
        result.append(args)
    }
    return result
}

func execute(program: inout [[String]], input: [Int]) -> Int {

    var variables = ["w": 0, "x": 0, "y": 0, "z": 0]
    var inputPointer = 0

    var ip = 0
    for line in program {
        switch line[0] {
        case "inp":
            variables[line[1]] = input[inputPointer]
            inputPointer += 1
        case "add":
            if let num = Int(line[2]) {
                variables[line[1]] = variables[line[1]]! + num
            } else {
                variables[line[1]] = variables[line[1]]! + variables[line[2]]!
            }
        case "mul":
            if let num = Int(line[2]) {
                variables[line[1]] = variables[line[1]]! * num
            } else {
                variables[line[1]] = variables[line[1]]! * variables[line[2]]!
            }
        case "div":
            if let num = Int(line[2]) {
                if num == 0 {
                    print("division by zero, line: \(ip) \(line)")
                }
                variables[line[1]] = variables[line[1]]! / num
            } else {
                if variables[line[2]]! == 0 {
                    print("division by zero, line: \(ip) \(line)")
                }
                variables[line[1]] = variables[line[1]]! / variables[line[2]]!
            }
        case "mod":
            if let num = Int(line[2]) {
                if variables[line[1]]! < 0 || num <= 0 {
                    print("division by zero, line: \(ip) \(line)")
                }
                variables[line[1]] = variables[line[1]]! / num
            } else {
                if variables[line[1]]! < 0 || variables[line[2]]! <= 0 {
                    print("division by zero, line: \(ip) \(line)")
                }
                variables[line[1]] = variables[line[1]]! / variables[line[2]]!
            }
        case "eql":
            if let num = Int(line[2]) {
                variables[line[1]] = variables[line[1]]! == num ? 1 : 0
            } else {
                variables[line[1]] = variables[line[1]]! == variables[line[2]]! ? 1 : 0
            }
        default: break
        }
        ip += 1
        print("execute: ",variables["z"]!)
    }
    if variables["z"] == 0 {
        return Int(input.reduce("") { $0 + String($1) })!
    }
    return variables["z"]!
}

func searchForNumber(program: [[String]]) -> Int {
    var prog = program
    var serialNumber = -1
    for i in (11111111111111...99999999999999).reversed() {
        //let inputStr = String(i)
        let inputStr = String(Int.random(in: 11111111111111...99999999999999))
        if !inputStr.contains(Character("0")) {
            //print(inputStr)
            let input = Array(inputStr).map { Int(String($0))! }
            /*
            let result = execute(program: &prog, input: input)
            if result != -1 {
                if result > serialNumber {
                    serialNumber = result
                }
            }
             */
            if programRewritten(input: input, inputZ: 0) == 0 {
                return Int(input.map { String($0) }.joined())!
            }
        }
    }
    return serialNumber
}

/*
x = (z % 26) + cc2
z = z / cc1

x = x == input[i] ? 1 : 0
x = x == 0 ? 1 : 0

z = z * ((25*x) + 1)
y = (input[i] + cc3) * x
z = z + y
*/

let c1 = [1,1,1,1,26,26,1,26,1,26,1,26,26,26]
let c2 = [13,11,11,10,-14,-4,11,-3,12,-12,13,-12,-15,-12]
let c3 = [10,16,0,13,7,11,11,10,16,8,15,2,5,10]

func programRewritten(input: [Int], inputZ: Int) -> Int {
    var z = inputZ
    print(input.map { String($0) }.joined())
    for i in 0..<input.count {
        if ((z % 26) + c2[i]) == input[i] {
            z = z / c1[i]
        } else {
            z = ((z / c1[i]) * 26) + (input[i] + c3[i])
        }
        print(z)
    }
    return z
}

struct IntPair : Hashable {
    let input: Int
    let z: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(input)
        hasher.combine(z)
    }
}

func possibleVariants(c1: Int, c2: Int, c3: Int, targetZ: Int) -> Set<IntPair> {
    var variants: Set<IntPair> = []   // input: possible Z
    var z = 0
    //print("t: ", targetZ)
    for i in 1...9 {
        var zz = 0
        while zz <= 100000 {
            z = zz

            let tmp = z / c1
            if ((z % 26) + c2) == i {
                z = tmp
            } else {
                z = (tmp * 26) + (i + c3)
            }

            if z == targetZ {
                variants.insert(IntPair(input: i, z: zz))
            }
            zz += 1
        }
    }
    return variants
}

func reverseRun() {
    let c1 = [1,1,1,1,26,26,1,26,1,26,1,26,26,26]
    let c2 = [13,11,11,10,-14,-4,11,-3,12,-12,13,-12,-15,-12]
    let c3 = [10,16,0,13,7,11,11,10,16,8,15,2,5,10]

    var space = [(String, Int)]()
    space.append(("",0))
    for i in (7..<c1.count).reversed() {
        print(i)
        var newSpace = [(String, Int)]()
        for row in space {
            let variants = possibleVariants(c1: c1[i], c2: c2[i], c3: c3[i], targetZ: row.1)
            for v in variants {
                newSpace.append((row.0 + String(v.input), v.z))
            }
        }
        space = newSpace
        print(space.count)
    }
    //let withStart0 = space.filter { $0.last!.0 == 0 }
    //print(space)
}

func possibleVariantsForward(c1: Int, c2: Int, c3: Int, inputZ: Int, allowedMax: Int) -> Set<IntPair> {
    var variants: Set<IntPair> = []   // input: result Z
    if inputZ > allowedMax {
        return []
    }
    var z = inputZ
    for i in 1...9 {
        z = inputZ
        if ((z % 26) + c2) == i {
            z = z / c1
        } else {
            z = ((z / c1) * 26) + (i + c3)
        }
        variants.insert(IntPair(input: i, z: z))
    }
    return variants
}

func forwardRun() {
    let c1 = [1,1,1,1,26,26,1,26,1,26,1,26,26,26]
    let c2 = [13,11,11,10,-14,-4,11,-3,12,-12,13,-12,-15,-12]
    let c3 = [10,16,0,13,7,11,11,10,16,8,15,2,5,10]

    var space = [(String, Int)]()
    space.append(("",0))
    var allowedMax = 1000000
    for i in 0..<c1.count {
        if i > 4 && i < 8 {
            allowedMax = 10000000
        } else if i >= 8 && i < 11 {
            allowedMax = 100000
        } else if i >= 11 {
            allowedMax = 10000
        }
        print(i)
        var newSpace = [(String, Int)]()
        for row in space {
            let variants = possibleVariantsForward(c1: c1[i], c2: c2[i], c3: c3[i], inputZ: row.1, allowedMax: allowedMax)
            for v in variants {
                newSpace.append((row.0 + String(v.input), v.z))
            }
        }
        space = newSpace
        print(space.count)
    }
    //let withStart0 = space.filter { $0.last!.0 == 0 }
    print(space)
}

struct ResultPair: Equatable {

    let number: String
    let z: Int

    static func == (lhs: ResultPair, rhs: ResultPair) -> Bool {
        return lhs.number == rhs.number && lhs.z == rhs.z
    }
}

func forwardRun2() {
    let c1 = [1,1,1,1,26,26,1,26,1,26,1,26,26,26]
    let c2 = [13,11,11,10,-14,-4,11,-3,12,-12,13,-12,-15,-12]
    let c3 = [10,16,0,13,7,11,11,10,16,8,15,2,5,10]

    var allowedMax = 1000000000
    var space = LinkedList<ResultPair>()
    space.appendLast(value: ResultPair(number: "", z: 0))
    for i in 0..<8 {
        if i > 4 && i < 8 {
            allowedMax = 10000000
        } else if i >= 8 && i < 11 {
            allowedMax = 1000000
        } else if i >= 11 {
            allowedMax = 100000
        }
        print(i)
        let newSpace = LinkedList<ResultPair>()
        space.actualToFirst()
        var j = 0
        while j < space.count {
            let actual = space.actual
            let variants = possibleVariantsForward(c1: c1[i], c2: c2[i], c3: c3[i], inputZ: actual!.value!.z, allowedMax: allowedMax)
            for v in variants {
                newSpace.appendLast(value: ResultPair(number: actual!.value!.number + String(v.input), z: v.z))
            }
            space.moveToRight(shift: 1)
            j += 1
        }
        space = newSpace
        print(space.count)
    }
    var i = 0
    var maxNumber = Int.min
    space.actualToFirst()
    while i < space.count {
        let actual = space.actual!.value!
        if actual.z == 0 {
            let x = Int(actual.number)!
            if x > maxNumber {
                maxNumber = x
            }
        }
        space.moveToRight(shift: 1)
        i += 1
    }
    print(maxNumber)
}

func forwardBackwardMatch() -> (Int, Int) {
    let c1 = [1,1,1,1,26,26,1,26,1,26,1,26,26,26]
    let c2 = [13,11,11,10,-14,-4,11,-3,12,-12,13,-12,-15,-12]
    let c3 = [10,16,0,13,7,11,11,10,16,8,15,2,5,10]

    var allowedMax = 1000000000
    var space = LinkedList<ResultPair>()
    space.appendLast(value: ResultPair(number: "", z: 0))
    for i in 0..<8 {
        print(i)
        let newSpace = LinkedList<ResultPair>()
        space.actualToFirst()
        var j = 0
        while j < space.count {
            let actual = space.actual
            let variants = possibleVariantsForward(c1: c1[i], c2: c2[i], c3: c3[i], inputZ: actual!.value!.z, allowedMax: allowedMax)
            for v in variants {
                newSpace.appendLast(value: ResultPair(number: actual!.value!.number + String(v.input), z: v.z))
            }
            space.moveToRight(shift: 1)
            j += 1
        }
        space = newSpace
        print(space.count)
    }

    var spaceBackward = LinkedList<ResultPair>()
    spaceBackward.appendLast(value: ResultPair(number: "", z: 0))
    for i in (8..<c1.count).reversed() {
        print(i)

        let newSpace = LinkedList<ResultPair>()
        spaceBackward.actualToFirst()
        var j = 0
        while j < spaceBackward.count {
            let actual = spaceBackward.actual
            let variants = possibleVariants(c1: c1[i], c2: c2[i], c3: c3[i], targetZ: actual!.value!.z)
            for v in variants {
                newSpace.appendLast(value: ResultPair(number: String(v.input) + actual!.value!.number, z: v.z))
            }
            spaceBackward.moveToRight(shift: 1)
            j += 1
        }
        spaceBackward = newSpace
        print(spaceBackward.count)
    }

    var i = 0
    var spaceDict = [Int: [String]]()
    space.actualToFirst()
    while i < space.count {
        let actual = space.actual!.value!
        if spaceDict[actual.z] == nil {
            spaceDict[actual.z] = [actual.number]
        } else {
            spaceDict[actual.z]!.append(actual.number)
        }
        space.moveToRight(shift: 1)
        i += 1
    }

    i = 0
    var backDict = [Int: [String]]()
    spaceBackward.actualToFirst()
    while i < spaceBackward.count {
        let actual = spaceBackward.actual!.value!
        if backDict[actual.z] == nil {
            backDict[actual.z] = [actual.number]
        } else {
            backDict[actual.z]!.append(actual.number)
        }
        spaceBackward.moveToRight(shift: 1)
        i += 1
    }

    var result = [(ResultPair, ResultPair)]()
    for key in spaceDict.keys {
        if let match = backDict[key] {
            for n in spaceDict[key]! {
                for m in match {
                    result.append((ResultPair(number: n, z: key), ResultPair(number: m, z: key)))
                }
            }
        }
        print(result.count)
    }

    var maximum = Int.min
    var minimum = Int.max
    for p in result {
        let x = Int(p.0.number + p.1.number)!
        if x > maximum {
            maximum = x
        }
        if x < minimum {
            minimum = x
        }
    }

    return (minimum, maximum)
}

var program = loadProgram(lines: lines)
//print(searchForNumber(program: program))


//let x1 = programRewritten(input: [1,1,1,1,1,1,1,1,1,1,1,1,1,1], inputZ: 0)
/*
let x2 = programRewritten(input: [5,4,3,2,1,9,8,7,6,5,4,3,2,1])
let x3 = programRewritten(input: [1,3,2,4,6,7,8,2,1,3,5,6,8,9])
let x4 = programRewritten(input: [9,1,9,1,9,1,9,1,9,1,9,1,9,1])

print(x1)
print(x2)
print(x3)
print(x4)
*/

//let x = searchForNumber(program: program)

/*
let start = DispatchTime.now()
let x = programRewritten(input: [1,3,5,7,9,2,4,6,8,9,9,9,9,9], inputZ: 0)
let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000
print("\(x)\n time: \(timeInterval)")

let start2 = DispatchTime.now()
let y = execute(program: &program, input: [1,3,5,7,9,2,4,6,8,9,9,9,9,9])
let end2 = DispatchTime.now()
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime) / 1_000_000_000
print("\(y)\n time: \(timeInterval2)")

print(x)
print(y)
*/

//print(searchForNumber(program: program))
/*
print(possibleVariants(c1: 26, c2: -12, c3: 10, targetZ: 0))
print(possibleVariants(c1: 26, c2: -15, c3: 5, targetZ: 13))
*/

//forwardRun2()
//reverseRun()

/*
let mathces = forwardBackwardMatch()

for i in 0..<100 {
    print(mathces[i])
}
*/

//let x1 = programRewritten(input: [5,4,6,5,4,2,1,9,4,8,1,4,5,3], inputZ: 0)
//print(x1)

print(forwardBackwardMatch())

let x1 = programRewritten(input: [9,8,9,9,8,5,1,9,5,9,6,9,9,7], inputZ: 0)
print(x1)
