//
//  main.swift
//  AOC2021_17
//
//  Created by Lubomír Kaštovský on 18.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

/**
 ** Puzzle Input **
 *      target area: x=81..129, y=-150..-108
 */

import Foundation


struct Area {
    let minx = 81
    let maxx = 129
    let miny = -150
    let maxy = -108
}


/*
struct Area {
    let minx = 20
    let maxx = 30
    let miny = -10
    let maxy = -5
}
*/

func step(x: inout Int, y: inout Int, velx: inout Int, vely: inout Int) {
    x += velx
    y += vely
    vely -= 1
    if velx > 0 {
        velx -= 1
    } else if velx < 0 {
        velx += 1
    }
}

func hitsTarget(velx: Int, vely: Int, area: Area) -> (Bool, Int) {
    var vx = velx
    var vy = vely
    var x = 0
    var y = 0
    var highestY = Int.min
    while true {

        // -----
        //step(x: &x, y: &y, velx: &vx, vely: &vy)

        x += vx
        y += vy
        vy -= 1
        if vx > 0 {
            vx -= 1
        } else if vx < 0 {
            vx += 1
        }
        // -----

        if x >= area.minx && x <= area.maxx && y >= area.miny && y <= area.maxy {
            //print("hit: ", x, y)
            return (true, (vely * (vely+1)/2))
        }

        if x > area.maxx || y < area.miny {
            //print("missed: ", x, y)
            break
        }
        if vx == 0 && (x < area.minx || x > area.maxx) {
            break
        }
    }
    return (false, 0)
}

func shooting(area: Area) -> (maxHeight: Int, hitVelocityCount: Int) {
    var maxY = Int.min
    // find min x velociy to reach the target
    var minX = 1
    while ((minX * (minX + 1)) / 2) < area.minx {
        minX += 1
    }
    //print("minX: ", minX)
    var hits: Set<String> = []
    for x in minX...area.maxx {
        // the maximum y is guessed, with higher numbers the results are same
        for y in area.miny...2000 {
            let hit = hitsTarget(velx: x, vely: y, area: area)
            if hit.0 && hit.1 > maxY {
                maxY = hit.1
            }
            if hit.0 {
                hits.insert(String(x) + "," + String(y))
            }
        }
    }
    //print(hits.count)
    return (maxY, hits.count)
}

let area = Area()

//print(hitsTarget(velx: 6, vely: 3, area: area))
let result = shooting(area: area)
print("part 1: ", result.maxHeight)
print("part 2: ", result.hitVelocityCount)


