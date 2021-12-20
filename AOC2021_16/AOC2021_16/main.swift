//
//  main.swift
//  AOC2021_16
//
//  Created by Lubomír Kaštovský on 17.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct Packet {
    let version: Int
    let type: Int
    let literalValue: Int?
    let lengthType: Int?
    let length: Int?
    var subpackets: [Packet]?

    public init(
        version: Int,
        type: Int,
        literalValue: Int? = nil,
        lengthType: Int? = nil,
        length: Int? = nil,
        subpackets: [Packet]? = nil
    ) {
        self.version = version
        self.type = type
        self.literalValue = literalValue
        self.lengthType = lengthType
        self.length = length
        self.subpackets = subpackets
    }
}

let lines = readLinesRemoveEmpty(str: inputString)

func toBinary(x: String) -> String {
    let str = String(Int(String(x), radix: 16)!, radix: 2)
    let size = str.count
    var result = String.init(repeating: "0", count: 4-size)
    result += str
    return result
}

func arrayOfBinaryStrings(hexString: String) -> [String] {
    return hexString.map { toBinary(x: String($0)) }.compactMap { $0 }.joined(separator: "").map { String($0) }
}

func parse(input: [String], startIndex: Int) -> (Int, [Packet]) {
    //print(input)
    var result = [Packet]()
    var i = startIndex
    while i < input.count {
        if i + 6 >= input.count { break }
        let version = Int(input[i] + input[i+1] + input[i+2], radix: 2)!
        let type = Int(input[i+3] + input[i+4] + input[i+5], radix: 2)!
        i += 6
        if type == 4 {
            var literal = ""
            while input[i] == "1" {
                literal += input[i+1] + input[i+2] + input[i+3] + input[i+4]
                i += 5
            }
            literal += input[i+1] + input[i+2] + input[i+3] + input[i+4]
            i += 5
            //print(literal)
            let value = Int(literal, radix: 2)!
            //print(value)
            result.append(Packet(version: version, type: type, literalValue: value))
            return (i, result)
        } else {
            let lengthType = input[i]
            if lengthType == "0" {
                if i + 1 >= input.count { break }
                i += 1
                if i + 15 > input.count { break }
                var length = ""
                for j in i..<i+15 {
                    length += input[j]
                }
                let lengthVal = Int(length, radix: 2)!
                i += 15
                let lastBit = i + lengthVal
                var subpackets = [Packet]()
                while i < lastBit {
                    let res = parse(input: input, startIndex: i)
                    i = res.0
                    subpackets += res.1
                }
                result.append(
                    Packet(
                        version: version,
                        type: type,
                        literalValue: nil,
                        lengthType: 0,
                        length: lengthVal,
                        subpackets: subpackets
                    )
                )
                return (i, result)
            } else { // "1"
                if i + 1 >= input.count { break }
                i += 1
                if i + 11 > input.count { break }
                var rep = ""
                for j in i..<i+11 {
                    rep += input[j]
                }
                let repeatVal = Int(rep, radix: 2)!
                i += 11
                var subpackets = [Packet]()
                for j in 0..<repeatVal {
                    let res = parse(input: input, startIndex: i)
                    i = res.0
                    subpackets += res.1
                }
                result.append(
                    Packet(
                        version: version,
                        type: type,
                        literalValue: nil,
                        lengthType: 0,
                        length: repeatVal,
                        subpackets: subpackets
                    )
                )
                return (i, result)
            }
        }
    }
    return (i, result)
}

func sumVersions(packets: [Packet]) -> Int {
    var sum = 0
    for packet in packets {
        sum += packet.version
        if let subpackets = packet.subpackets {
            sum += sumVersions(packets: subpackets)
        }
    }
    return sum
}

func evaluatePacket(inputPacket: Packet?) -> Int {
    guard let packet = inputPacket else {
        return 0
    }
    //print("---")
    switch packet.type {
    case 0:
        if let subpackets = packet.subpackets {
            var sum = 0
            for subpacket in subpackets {
                let val = evaluatePacket(inputPacket: subpacket)
                //print("adding: ", val)
                sum += val
            }
            //print("sum: ", sum)
            return sum
        }
        return 0
    case 1:
        if let subpackets = packet.subpackets {
            var product = 1
            for subpacket in subpackets {
                let val = evaluatePacket(inputPacket: subpacket)
                //print("mult: ", val)
                product = product * val
            }
            //print("product: ", product)
            return product
        }
        return 0
    case 2:
        if let subpackets = packet.subpackets {
            var min = Int.max
            for subpacket in subpackets {
                let val = evaluatePacket(inputPacket: subpacket)
                //print("is min: ", val)
                if val < min {
                    min = val
                }
            }
            //print("min: ", min)
            return min
        }
        return 0
    case 3:
        if let subpackets = packet.subpackets {
            var max = Int.min
            for subpacket in subpackets {
                let val = evaluatePacket(inputPacket: subpacket)
                //print("is max: ", max)
                if val > max {
                    max = val
                }
            }
            //print("max: ", max)
            return max
        }
        return 0
    case 4:
        //print("literal: ", packet.literalValue!)
        return packet.literalValue!
    case 5:
        if let subpackets = packet.subpackets {
            let first = evaluatePacket(inputPacket: subpackets[0])
            let second = evaluatePacket(inputPacket: subpackets[1])
            //print("greater :", first, ", ", second)
            if first > second {
                return 1
            } else {
                return 0
            }
        }
        return 0
    case 6:
        if let subpackets = packet.subpackets {
            let first = evaluatePacket(inputPacket: subpackets[0])
            let second = evaluatePacket(inputPacket: subpackets[1])
            //print("less :", first, ", ", second)
            if first < second {
                return 1
            } else {
                return 0
            }
        }
        return 0
    case 7:
        if let subpackets = packet.subpackets {
            let first = evaluatePacket(inputPacket: subpackets[0])
            let second = evaluatePacket(inputPacket: subpackets[1])
            //print("equal :", first, ", ", second)
            if first == second {
                return 1
            } else {
                return 0
            }
        }
        return 0
    default: return 0
    }
}

//print(parse(input: arrayOfBinaryStrings(hexString: "D2FE28"), startIndex: 0))

//print(parse(input: arrayOfBinaryStrings(hexString: "38006F45291200"), startIndex: 0))

//print(parse(input: arrayOfBinaryStrings(hexString: "EE00D40C823060"), startIndex: 0))

//let packets = parse(input: arrayOfBinaryStrings(hexString: "A0016C880162017C3686B18A3D4780"), startIndex: 0)
//print(packets)
//print(sumVersions(packets: packets.1))

let input = parse(input: arrayOfBinaryStrings(hexString: lines[0]), startIndex: 0).1
//print(input.count)
print("part 1: ", sumVersions(packets: input))

//let test1 = parse(input: arrayOfBinaryStrings(hexString: "9C0141080250320F1802104A08"), startIndex: 0).1
//print(test1)
//print(evaluatePacket(inputPacket: test1[0]))

//let test2 = parse(input: arrayOfBinaryStrings(hexString: "04005AC33890"), startIndex: 0).1
//print(test2)
//print(evaluatePacket(inputPacket: test2[0]))

//print(input)
print("part 2: ", evaluatePacket(inputPacket: input[0]))
//print(Int.max)
