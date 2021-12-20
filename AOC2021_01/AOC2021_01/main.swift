//
//  main.swift
//  AOC2021_01
//
//  Created by Lubomír Kaštovský on 03.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

//print(inputString)

let lines = readLinesRemoveEmpty(str: inputString)
let depths = lines.compactMap { Int($0) }

//print(depths)

func increasedDepthCount(depths: [Int]) -> Int {
    var count = 0
    var lastDepth = Int.max
    for depth in depths {
        if lastDepth < depth {
            count += 1
        }
        lastDepth = depth
    }
    return count
}

func increasedDepthNoiseRemovedCount(depths: [Int]) -> Int {
    var count = 0
    var lastDepth = Int.max
    for i in 0..<depths.count-2 {
        let depth = depths[i] + depths[i+1] + depths[i+2]
        if lastDepth < depth {
            count += 1
        }
        lastDepth = depth
        print([depths[i+2]])
    }
    return count
}


print("part 1: ", increasedDepthCount(depths: depths))
print("part 2: ", increasedDepthNoiseRemovedCount(depths: depths))
