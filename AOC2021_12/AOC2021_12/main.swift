//
//  main.swift
//  AOC2021_12
//
//  Created by Lubomír Kaštovský on 12.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

typealias Paths = [String: [String]]

let lines = readLinesRemoveEmpty(str: inputString)

func createPathDict(lines: [String]) -> Paths {

    var paths = Paths()
    for line in lines {
        let args = line.components(separatedBy: ["-"])
        if let path = paths[args[0]] {
            let newPath = path + [args[1]]
            paths[args[0]] = newPath
        } else {
            paths[args[0]] = [args[1]]
        }
        if let path = paths[args[1]] {
            let newPath = path + [args[0]]
            paths[args[1]] = newPath
        } else {
            paths[args[1]] = [args[0]]
        }
    }
    return paths
}

let paths = createPathDict(lines: lines)
print(paths)

func generateRoutes(paths: Paths, start: [String]) -> [[String]] {
    var routes = [[String]]()
    let nodes = paths[start.last!]!
    for node in nodes {
        if node.first!.isUppercase {
            let newRoutes = generateRoutes(paths: paths, start: start + [node])
            routes = routes + newRoutes
        } else {
            if !start.contains(node) {
                if node == "end" {
                    routes.append(start + ["end"])
                } else {
                    let newRoutes = generateRoutes(paths: paths, start: start + [node])
                    routes = routes + newRoutes
                }
            }
        }
    }
    return routes
}

func canInsertSmall(small: String, route: [String]) -> Bool {
    if small == "start" {
        return !route.contains("start")
    }
    if small == "end" {
        return !route.contains("end")
    }
    if !route.contains(small) {
        return true
    } else {
        // check it has already two small
        for node in route {
            if node.first!.isLowercase {
                let count = route.filter { $0 == node }.count
                if count > 1 {
                    return false
                }
            }
        }
        return true
    }
}

func generateRoutes2(paths: Paths, start: [String]) -> [[String]] {
    var routes = [[String]]()
    let nodes = paths[start.last!]!
    for node in nodes {
        if node.first!.isUppercase {
            let newRoutes = generateRoutes2(paths: paths, start: start + [node])
            routes = routes + newRoutes
        } else {
            if canInsertSmall(small: node, route: start) {
                if node == "end" {
                    routes.append(start + ["end"])
                } else {
                    let newRoutes = generateRoutes2(paths: paths, start: start + [node])
                    routes = routes + newRoutes
                }
            }
        }
    }
    return routes
}

let routes = generateRoutes(paths: paths, start: ["start"])
print(routes.count)

let routes2 = generateRoutes2(paths: paths, start: ["start"])
//print(routes2)
print(routes2.count)
