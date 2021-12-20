//
//  main.swift
//  AOC2021_15
//
//  Created by Lubomír Kaštovský on 15.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct Node {
    let id: Int // x*10000 + y
    let distance: Int
}

typealias Graph = [Int: [Node]]

let lines = readLinesRemoveEmpty(str: inputString)

func getId(x: Int, y: Int) ->  Int {
    return x*10000 + y
}

func bigOne(intArray: [[Int]]) -> [[Int]] {
    var result = [[Int]]()
    for _ in 0..<5*intArray.count {
        let row = [Int].init(repeating: 0, count: 5*intArray[0].count)
        result.append(row)
    }
    for y in 0..<intArray.count {
        for x in 0..<intArray[y].count {
            var val = intArray[y][x]
            for i in 0..<5 {
                result[y][x+(i*intArray[y].count)] = val
                val = val == 9 ? 1 : val+1
            }
        }
    }
    for x in 0..<result[0].count {
        for y in 0..<intArray.count {
            var val = result[y][x]
            for i in 0..<5 {
                result[y+(i*intArray.count)][x] = val
                val = val == 9 ? 1 : val+1
            }
        }
    }
    return result
}

func printMatrix(matrix: [[Int]]) {
    for row in matrix {
        var str = ""
        for col in row {
            str += String(col)
        }
        print(str)
    }
}

func createGraph(lines: [String], big: Bool = false) -> Graph {
    var result = Graph()
    var intArray = [[Int]]()
    for line in lines {
        let nums = line.map { Int(String($0))! }
        intArray.append(nums)
    }

    if big {
        intArray = bigOne(intArray: intArray)
        //printMatrix(matrix: intArray)
    }

    let maxX = intArray[0].count - 1
    let maxY = intArray.count - 1
    for y in 0..<intArray.count {
        for x in 0..<intArray[y].count {
            var nodes = [Node]()
            if x > 0 {
                let node = Node(id: getId(x: x-1, y: y), distance: intArray[y][x-1])
                nodes.append(node)
            }
            if x < maxX {
                let node = Node(id: getId(x: x+1, y: y), distance: intArray[y][x+1])
                nodes.append(node)
            }
            if y > 0 {
                let node = Node(id: getId(x: x, y: y-1), distance: intArray[y-1][x])
                nodes.append(node)
            }
            if y < maxY {
                let node = Node(id: getId(x: x, y: y+1), distance: intArray[y+1][x])
                nodes.append(node)
            }
            result[getId(x: x, y: y)] = nodes
        }
    }
    return result
}

/*
 1  function Dijkstra(E, V, s):
 2     for each vertex v in V:           // Inicializace
 3         d[v] := infinity              // Zatím neznámá vzdálenost z počátku s do vrcholu v
 4         p[v] := undefined             // Předchozí vrchol na nejkratší cestě z počátku s k cíli
 5     d[s] := 0                         // Vzdálenost z s do s
 6     N := V                            // Množina všech dosud nenavštívených vrcholů. Na začátku všech vrcholů.
 7     while N is not empty:             // Samotný algoritmus
 8         u := extract_min(N)           // Vezměme "nejlepší" vrchol
 9         for each neighbor v of u:
10             alt = d[u] + l(u, v)      // v 1. smyčce cyklu u je s d[u] = 0
11             if alt < d[v]
12                 d[v] := alt
13                 p[v] := u
 */

func dijkstra(graph: Graph, targetX: Int, targetY: Int) -> Int {
    var notVisited = [Int: Int]()
    let targetId = getId(x: targetX, y: targetY)
    var targetMinDistance = Int.max
    for key in graph.keys {
        notVisited[key] = Int.max
    }
    notVisited[0] = 0
    while !notVisited.isEmpty {
        let bestNode = notVisited.min(by: { a, b in a.value < b.value} )!.key // this is the most problematic line, searching for the minimum in a huge space
        for nei in graph[bestNode]! {
            if notVisited[nei.id] != nil {
                let distance = notVisited[bestNode]! + nei.distance
                if distance < notVisited[nei.id]! {
                    notVisited[nei.id]! = distance
                }
            }
        }
        if bestNode == targetId && notVisited[bestNode]! < targetMinDistance {
            targetMinDistance = notVisited[bestNode]!
        }
        notVisited[bestNode] = nil
    }
    return targetMinDistance
}

let graph = createGraph(lines: lines)
let bigGraph = createGraph(lines: lines, big: true)

/*
let distance = dijkstra(graph: graph, targetX: lines[0].count - 1, targetY: lines.count - 1)
let bigDistance = dijkstra(graph: bigGraph, targetX: (lines[0].count*5) - 1, targetY: (lines.count*5) - 1)
*/

//print(distance)
//print(bigDistance)

let start = DispatchTime.now()
let part1 = dijkstra(graph: graph, targetX: lines[0].count - 1, targetY: lines.count - 1)
let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

print("part 1: \(part1), time: \(timeInterval)")

let start2 = DispatchTime.now()
let part2 = dijkstra(graph: bigGraph, targetX: (lines[0].count*5) - 1, targetY: (lines.count*5) - 1)
let end2 = DispatchTime.now()
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000

print("part 2: \(part2), time: \(timeInterval2)")

