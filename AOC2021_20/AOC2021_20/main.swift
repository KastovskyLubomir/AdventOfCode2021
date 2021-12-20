//
//  main.swift
//  AOC2021_20
//
//  Created by Lubomír Kaštovský on 20.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct Image {
    var minx: Int
    var maxx: Int
    var miny: Int
    var maxy: Int
    var pixels: Set<Int>
    var isInfinityLit: Bool // says if it is on or off
}

let shiftX = 1000000

let lines = readLinesRemoveEmpty(str: inputString)

func loadPattern(lines: [String]) -> [Character] {
    var result = [Character]()
    for c in lines[0] {
        result.append(c)
    }
    return result
}

// set top left to 500, 500
func loadImage(lines: [String]) -> Image {
    let offset = 500
    var image = Image(minx: offset, maxx: offset+lines[1].count-1, miny: offset, maxy: offset+lines.count-2, pixels: [], isInfinityLit: false)
    var y = offset
    for i in 1..<lines.count {
        var x = offset
        for c in lines[i] {
            if c == Character("#") {
                let str = x*shiftX + y
                image.pixels.insert(str)
            }
            x += 1
        }
        y += 1
    }
    return image
}

func strPoint(x: Int, y: Int) -> String {
    return String(x) + "," + String(y)
}

func enhancePixels(image: Image, pattern: [Character]) -> Image {
    let newMaxX = image.maxx+1
    let newMinX = image.minx-1
    let newMaxY = image.maxy+1
    let newMinY = image.miny-1
    var newInfinityLit = false
    if image.isInfinityLit {
        if pattern.last == Character("#") {
            newInfinityLit = true
        } else {
            newInfinityLit = false
        }
    } else {
        if pattern.first == Character("#") {
            newInfinityLit = true
        } else {
            newInfinityLit = false
        }
    }
    var newImage = Image(minx: newMinX, maxx: newMaxX, miny: newMinY, maxy: newMaxY, pixels: [], isInfinityLit: newInfinityLit)
    var strBinary = ""
    for y in newMinY...newMaxY {
        for x in newMinX...newMaxX {
            strBinary = ""
            for yy in y-1...y+1 {
                for xx in x-1...x+1 {
                    if xx <= newMinX || xx >= newMaxX || yy <= newMinY || yy >= newMaxY {
                        strBinary += image.isInfinityLit ? "1" : "0"
                    } else {
                        strBinary += image.pixels.contains(xx*shiftX + yy) ? "1" : "0"
                    }
                }
            }
            let index = Int(strBinary, radix: 2)!
            if pattern[index] == Character("#") {
                newImage.pixels.insert(x*shiftX + y)
            }
        }
    }
    return newImage
}

func printImage(image: Image) {
    print("minx: \(image.minx), miny: \(image.miny), maxx: \(image.maxx), maxy: \(image.maxy)")
    for y in image.miny...image.maxy {
        var str = ""
        for x in image.minx...image.maxx {
            if image.pixels.contains(x*shiftX + y) {
                str += "#"
            } else {
                str += "."
            }
        }
        print(str)
    }
}

func enhancing(times: Int, image: Image, pattern: [Character]) -> Image {
    var newImage = image
    //printImage(image: newImage)
    //print("-----")
    for i in 0..<times {
        newImage = enhancePixels(image: newImage, pattern: pattern)
        //printImage(image: newImage)
        //print("-----")
        //print(i+1)
    }
    return newImage
}

let pattern = loadPattern(lines: lines)
let image = loadImage(lines: lines)

//print(pattern)
//print(pattern.count)
/*
printImage(image: image)
print("-----")
let enhanced = enhancePixels(image: image, pattern: pattern)
printImage(image: enhanced)
*/

let part1 = enhancing(times: 2, image: image, pattern: pattern)
//print("-----")
//printImage(image: part1)
print("part 1: ", part1.pixels.count)

let part2 = enhancing(times: 50, image: image, pattern: pattern)
print("part 2: ", part2.pixels.count)
//printImage(image: part2)
