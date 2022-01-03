//
//  main.swift
//  AOC2021_22
//
//  Created by Lubomír Kaštovský on 22.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

enum State: Int {
    case on
    case off
}

enum IntersectionType: String {
    case onOn
    case onOff
    case offOn
    case offOff
}

struct Cuboid {
    let id: String
    let state: State
    let intersectionType: IntersectionType?
    let xmin: Int
    let xmax: Int
    let ymin: Int
    let ymax: Int
    let zmin: Int
    let zmax: Int
    var intersections: [Cuboid]
}

let lines = readLinesRemoveEmpty(str: inputString)

func loadCuboids(lines: [String]) -> [Cuboid] {
    var result = [Cuboid]()
    var id = 0
    for line in lines {
        let args = line.components(separatedBy: [",", " "])
        let state: State = args[0] == "on" ? .on : .off
        let x = args[1].components(separatedBy: ["=", "."])
        let y = args[2].components(separatedBy: ["=", "."])
        let z = args[3].components(separatedBy: ["=", "."])
        let cuboid = Cuboid(
            id: String(id),
            state: state,
            intersectionType: nil,
            xmin: Int(x[1])!, xmax: Int(x[3])!,
            ymin: Int(y[1])!, ymax: Int(y[3])!,
            zmin: Int(z[1])!, zmax: Int(z[3])!,
            intersections: []
        )
        result.append(cuboid)
        id += 1
    }
    return result
}

func sumOn(cuboids: [Cuboid]) -> Int {
    var onPoints: Set<String> = []
    for cuboid in cuboids {
        if cuboid.xmin >= -50 && cuboid.xmax <= 50 {
            for x in cuboid.xmin...cuboid.xmax {
                for y in cuboid.ymin...cuboid.ymax {
                    for z in cuboid.zmin...cuboid.zmax {
                        let key = String(x) + "," + String(y) + "," + String(z)
                        if cuboid.state == .on {
                            onPoints.insert(key)
                        } else {
                            onPoints.remove(key)
                        }
                    }
                }
            }
        }
    }
    print(onPoints)
    return onPoints.count
}

// nil if no intersection
func intervalIntersection(amin: Int, amax: Int, bmin: Int, bmax: Int) -> (min: Int, max: Int)? {
    if amin <= bmin && amax >= bmin && amax <= bmax {
        return (min: bmin, max: amax)
    } else if bmin <= amin && amin <= bmax && bmax <= amax {
        return (min: amin, max: bmax)
    } else if amin <= bmin && amax >= bmax {
        return (min: bmin, max: bmax)
    } else if bmin <= amin && bmax >= amax {
        return (min: amin, max: amax)
    }
    return nil
}

func intersectionType(cuboidA: Cuboid, cuboidB: Cuboid) -> IntersectionType {
    if cuboidA.state == .on && cuboidB.state == .on {
        return .onOn
    }
    if cuboidA.state == .on && cuboidB.state == .off {
        return .onOff
    }
    if cuboidA.state == .off && cuboidB.state == .on {
        return .offOn
    }
    return .offOff
}

func cuboidIntersection(cuboidA: Cuboid, cuboidB: Cuboid) -> Cuboid? {
    if let x = intervalIntersection(amin: cuboidA.xmin, amax: cuboidA.xmax, bmin: cuboidB.xmin, bmax: cuboidB.xmax),
       let y = intervalIntersection(amin: cuboidA.ymin, amax: cuboidA.ymax, bmin: cuboidB.ymin, bmax: cuboidB.ymax),
       let z = intervalIntersection(amin: cuboidA.zmin, amax: cuboidA.zmax, bmin: cuboidB.zmin, bmax: cuboidB.zmax) {
        // intersection state is the one that has the B cuboid
        return Cuboid(
            id: "[" + cuboidA.id + "-" + cuboidB.id + "]",
            state: cuboidB.state,
            intersectionType: intersectionType(cuboidA: cuboidA, cuboidB: cuboidB),
            xmin: x.min, xmax: x.max,
            ymin: y.min, ymax: y.max,
            zmin: z.min, zmax: z.max,
            intersections: []
        )
    }
    return nil
}

func cuboidPointsCount(cuboid: Cuboid) -> Int {
    return abs(cuboid.xmax - cuboid.xmin + 1) * abs(cuboid.ymax - cuboid.ymin + 1) * abs(cuboid.zmax - cuboid.zmin + 1)
}

func allIntersections(cuboids: [Cuboid]) -> [Cuboid] {
    var result = cuboids
    for i in 0..<cuboids.count {
        for j in 0..<cuboids.count {
            if i != j {
                if let intersection = cuboidIntersection(cuboidA: cuboids[i], cuboidB: cuboids[j]) {
                    result[i].intersections.append(intersection)
                }
            }
        }
    }
    return result
}

func addCuboids(cuboidA: Cuboid, cuboidB: Cuboid) -> Int {
    var intersectionCount = 0
    let intersection = cuboidA.intersections.first { $0.id == (cuboidA.id + "-" + cuboidB.id) }
    if intersection != nil {
        intersectionCount = cuboidPointsCount(cuboid: intersection!)
    }
    return cuboidPointsCount(cuboid: cuboidA) + (cuboidPointsCount(cuboid: cuboidB) - intersectionCount)
}

func applyCuboids(cuboids: [Cuboid]) -> [Cuboid] {
    var result = [Cuboid]()
    for cuboid in cuboids {
        var newCuboid = cuboid
        var intersections = [Cuboid]()
        for res in result {
            if cuboid.id != res.id {
                if let intersection = cuboidIntersection(cuboidA: res, cuboidB: newCuboid) {
                    intersections.append(intersection)
                }
            }
        }
        newCuboid.intersections = applyCuboids(cuboids: intersections)
        result.append(newCuboid)
    }
    return result
}

func sumCuboids(cuboids: [Cuboid]) -> Int {
    var sum = 0
    for cuboid in cuboids {
        if cuboid.state == .on {
            sum += cuboidPointsCount(cuboid: cuboid) - sumCuboids(cuboids: cuboid.intersections)
        } else {
            let ss = cuboidPointsCount(cuboid: cuboid)
            let ins = sumCuboids(cuboids: cuboid.intersections)
            if cuboid.id.contains("-") {
                sum += ss - ins
            } else {
                sum -= ins
            }
        }
    }
    return sum
}

func sumFromIntersections(cuboids: [Cuboid]) -> Int {
    var sum = 0
    for cuboid in cuboids {
        sum += cuboidPointsCount(cuboid: cuboid) * ((cuboid.state) == .on ? 1 : -1)
        for inter in cuboid.intersections {
            let args = inter.id.components(separatedBy: ["[","-","]"])
            if inter.state == .off {
                sum -= cuboidPointsCount(cuboid: inter)
            } else if Int(args[1])! > Int(args[2])! {
                sum += cuboidPointsCount(cuboid: inter)
            } else {
                sum -= cuboidPointsCount(cuboid: inter)
            }
        }
    }
    return sum
}

func reboot(cuboids: [Cuboid], index: Int, cuboidSum:  ) -> Int {

    var sum
}



func printCuboids(_ cuboids: [Cuboid], level: Int) {
    for cuboid in cuboids {
        let spaces = String.init(repeating: "   ", count: level)
        print("\(spaces)\(cuboid.id): \(cuboid.state == .on ? "on" : "off"), \(cuboid.intersectionType?.rawValue ?? "nil") x: \(cuboid.xmin), \(cuboid.xmax), y: \(cuboid.ymin), \(cuboid.ymax), z: \(cuboid.zmin), \(cuboid.zmax)")
        printCuboids(cuboid.intersections, level: level + 1)
        /*
        for intersec in cuboid.intersections {
            print("     \(intersec.id): \(intersec.state == .on ? "on" : "off"), x: \(intersec.xmin), \(intersec.xmax), y: \(intersec.ymin), \(intersec.ymax), z: \(intersec.zmin), \(intersec.zmax)")
        }
         */
    }
}

let cuboids = loadCuboids(lines: lines)
print(cuboids.count)
print(sumOn(cuboids: cuboids))

let allInters = allIntersections(cuboids: cuboids)
printCuboids(allInters, level: 0)
print(sumFromIntersections(cuboids: allInters))

let resolvedCuboids = applyCuboids(cuboids: cuboids)
printCuboids(resolvedCuboids, level: 0)
print(sumCuboids(cuboids: resolvedCuboids))
