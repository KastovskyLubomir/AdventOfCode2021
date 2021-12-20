//
//  main.swift
//  AOC2021_19
//
//  Created by Lubomír Kaštovský on 19.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//


/*
 Rotation in 3D

 In 3D we need to take in to account the third axis. Rotating a vector around the origin (a point) in 2D simply means rotating it around the Z-axis (a line) in 3D; since we're rotating around Z-axis, its coordinate should be kept constant i.e. 0° (rotation happens on the XY plane in 3D). In 3D rotating around the Z-axis would be

     |cos θ   −sin θ   0| |x|   |x cos θ − y sin θ|   |x'|
     |sin θ    cos θ   0| |y| = |x sin θ + y cos θ| = |y'|
     |  0       0      1| |z|   |        z        |   |z'|
 around the Y-axis would be

     | cos θ    0   sin θ| |x|   | x cos θ + z sin θ|   |x'|
     |   0      1       0| |y| = |         y        | = |y'|
     |−sin θ    0   cos θ| |z|   |−x sin θ + z cos θ|   |z'|
 around the X-axis would be

     |1     0           0| |x|   |        x        |   |x'|
     |0   cos θ    −sin θ| |y| = |y cos θ − z sin θ| = |y'|
     |0   sin θ     cos θ| |z|   |y sin θ + z cos θ|   |z'|
 Note 1: axis around which rotation is done has no sine or cosine elements in the matrix.

 Note 2: This method of performing rotations follows the Euler angle rotation system, which is simple to teach and easy to grasp. This works perfectly fine for 2D and for simple 3D cases; but when rotation needs to be performed around all three axes at the same time then Euler angles may not be sufficient due to an inherent deficiency in this system which manifests itself as Gimbal lock. People resort to Quaternions in such situations, which is more advanced than this but doesn't suffer from Gimbal locks when used correctly.

 */


/*
    90 degrees
    cos 90 = 0
    sin 90 = 1

     Z-axis
x    0 -1  0
y    1  0  0
z    0  0  1

    Y-axis
x    0  0  1
y    0  1  0
z   -1  0  0

    X-axis
x    1  0  0
y    0  0 -1
z    0  1  0

 */

import Foundation
import Accelerate
import simd

enum RotationAxis: Int {
    case x
    case y
    case z
}

let rotateZMatrix = float3x3(
    rows: [
        simd_float3(0, -1, 0),
        simd_float3(1, 0, 0),
        simd_float3(0, 0, 1)
    ]
)

let rotateYMatrix = float3x3(
    rows: [
        simd_float3(0, 0, 1),
        simd_float3(0, 1, 0),
        simd_float3(-1, 0, 0)
    ]
)

let rotateXMatrix = float3x3(
    rows: [
        simd_float3(1, 0, 0),
        simd_float3(0, 0, -1),
        simd_float3(0, 1, 0)
    ]
)

func rotateVector(vector: simd_float3, axis: RotationAxis) -> simd_float3 {
    switch axis {
    case .x:
        return vector * rotateXMatrix
    case .y:
        return vector * rotateYMatrix
    case .z:
        return vector * rotateZMatrix
    }
}

func generateRotations(vector: simd_float3) -> [simd_float3] {
    var rotations: [simd_float3] = []
    var rotated = vector
    for x in 0..<2 {
        for y in 0..<4 {
            for z in 0..<4 {
                if !(x == 1 && (y == 1 || y == 3)) {
                    //print("--> inserting : \(rotated), x:\(x), y:\(y), z:\(z)")
                    rotations.append(rotated)
                }
                rotated = rotateVector(vector: rotated, axis: .z)
            }
            rotated = rotateVector(vector: rotated, axis: .y)
        }
        rotated = rotateVector(vector: rotated, axis: .x)
    }
    return rotations
}

// this takes one scanner and creates rotations for it
// every row(array) in result array is whole scanner roatated 90 degrees around one axis
// so it will create 24 variants of given scanner
func scannerRotations(vectors: [simd_float3]) -> [[simd_float3]] {
    var result = [[simd_float3]].init(repeating: [], count: vectors.count)
    for vector in vectors {
        let rotations = generateRotations(vector: vector)
        var i = 0
        for rotation in rotations {
            result[i].append(rotation)
            i += 1
        }
    }
    return result
}

// returning:
//  match result
//  all points from scanner B shifted to the scanner A coordinates
//  the matched scanner coordinates center
func scannersMatching(scA: [simd_float3], scB: [simd_float3]) -> (matched: Bool, points: [simd_float3], center: simd_float3) {
    var matchingCount = 0
    // generate all posible rotations
    let rotations = scannerRotations(vectors: scB)
    // test every rotation until there is one matching
    for rotation in rotations {
        // set two points from both scanners as matching
        for pointA in scA {
            for pointB in rotation {
                // compute axis distance
                let dx = pointB.x - pointA.x
                let dy = pointB.y - pointA.y
                let dz = pointB.z - pointA.z
                // print(dx, dy, dz)
                // recompute points of B using axis distance
                // try to find 12 matching points
                matchingCount = 0
                for pointToShift in rotation {
                    let shiftedPoint = simd_float3(x: pointToShift.x - dx, y: pointToShift.y - dy, z: pointToShift.z - dz)
                    //print(shiftedPoint)
                    if scA.contains(shiftedPoint) {
                        matchingCount += 1
                    }
                }
                if matchingCount >= 12 {
                    //print(dx, dy, dz)
                    return (
                        matched: true,
                        points: rotation.compactMap { simd_float3(x: $0.x-dx, y: $0.y-dy, z: $0.z-dz) },
                        center: simd_float3(x: -dx, y: -dy, z: -dz)
                    )
                }
            }
        }
    }
    return (false, [], simd_float3(x: 0, y: 0, z: 0))
}

func mergeScanners(scA: [simd_float3], scB: [simd_float3]) -> [simd_float3] {
    var result = scA
    for point in scB {
        if !result.contains(point) {
            result.append(point)
        }
    }
    return result
}

func findMatchingScanners(scannersIn: [[simd_float3]]) -> (Set<simd_float3>, [simd_float3]) {
    var scanners = scannersIn
    var resSet: Set<simd_float3> = []
    var centers = [simd_float3(x: 0, y: 0, z: 0)] // insert first scanner center
    var i = 0
    var j = 0
    while i < scanners.count {
        j = i + 1
        while j < scanners.count {
            let res = scannersMatching(scA: scanners[i], scB: scanners[j])
            if res.matched {
                scanners[i] = mergeScanners(scA: scanners[i], scB: res.points)
                scanners[i].forEach { resSet.insert($0) }
                print("beacons located: ", resSet.count)
                scanners.remove(at: j)
                centers.append(res.center)
                j = 0
                i = -1
                break
            }
            j += 1
        }
        i += 1
    }
    return (resSet, centers)
}

func loadScanners(lines: [String]) -> [[simd_float3]] {
    var result = [[simd_float3]]()
    var scanner = [simd_float3]()
    for line in lines {
        if line.contains("s") {
            if !scanner.isEmpty {
                result.append(scanner)
            }
            scanner = [simd_float3]()
        } else {
            let args = line.components(separatedBy: [","])
            scanner.append(simd_float3(x: Float(args[0])!, y: Float(args[1])!, z: Float(args[2])!))
        }
    }
    result.append(scanner)
    return result
}

func scannerPositionMaxDistance(positions: [simd_float3]) -> Int {
    var maxDistance = Int.min
    for i in 0..<positions.count {
        for j in i+1..<positions.count {
            let a = positions[i]
            let b = positions[j]
            let distance = Int(abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z))
            if distance > maxDistance {
                maxDistance = distance
            }
        }
    }
    return maxDistance
}

let lines = readLinesRemoveEmpty(str: inputString)
let scanners = loadScanners(lines: lines)
//print(scanners)
//print(generateRotations(vector: simd_float3(-3,7,-6)).count)
//let rotatedScanner = scannerRotations(vectors: scanners[0])
//print(scannersMatching(scA: scanners[0], scB: rotatedScanner[2]))
//print(scannersMatching(scA: scanners[0], scB: scanners[1]))

let result = findMatchingScanners(scannersIn: scanners)
print("part 1: ", result.0.count)
print("part 2: ", scannerPositionMaxDistance(positions: result.1))
