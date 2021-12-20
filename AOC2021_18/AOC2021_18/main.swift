//
//  main.swift
//  AOC2021_18
//
//  Created by Lubomír Kaštovský on 18.12.2021.
//  Copyright © 2021 Lubomír Kaštovský. All rights reserved.
//

import Foundation

class Node {
    var left: Node?
    var right: Node?
    var value: Int?
    var leftNeighbor: Node?
    var rightNeighbor: Node?

    init(left: Node? = nil, right: Node? = nil, value: Int? = nil, leftNeighbor: Node? = nil, rightNeighbor: Node? = nil) {
        self.left = left
        self.right = right
        self.value = value
        self.leftNeighbor = leftNeighbor
        self.rightNeighbor = rightNeighbor
    }
}

let lines = readLinesRemoveEmpty(str: inputString)

func addNumbers(a: String, b: String) -> String {
    return "[" + a + "," + b + "]"
}

func topLevelCommaSplit(a: String) -> (String, String) {
    var b = a
    b.removeFirst()
    b.removeLast()
    let c = Array(b)
    var i = 0
    var bracket = 0
    while i < c.count {
        if c[i] == "[" {
            bracket += 1
        } else if c[i] == "]" {
            bracket -= 1
        } else if c[i] == "," {
            if bracket == 0 {
                let a1 = c[0..<i]
                let a2 = c[i+1..<c.count]
                return (String(a1), String(a2))
            }
        }
        i += 1
    }
    return ("","")
}

func tree(number: String, neighbor: Node?) -> (newNode: Node, neighbor: Node)  {
    var left: Node? = nil
    var right: Node? = nil
    let splited = topLevelCommaSplit(a: number)
    var newNeighbor: Node? = nil
    let node = Node(left: nil, right: nil, value: nil, leftNeighbor: nil)
    if let val = Int(splited.0) {
        left = Node(left: nil, right: nil, value: val, leftNeighbor: neighbor)
        neighbor?.rightNeighbor = left
        newNeighbor = left
    } else {
        let result = tree(number: splited.0, neighbor: neighbor)
        left = result.newNode
        newNeighbor = result.neighbor
    }
    if let val = Int(splited.1) {
        right = Node(left: nil, right: nil, value: val, leftNeighbor: newNeighbor)
        newNeighbor?.rightNeighbor = right
        newNeighbor = right
    } else {
        let result = tree(number: splited.1, neighbor: newNeighbor)
        right = result.newNode
        newNeighbor = result.neighbor
    }
    node.left = left
    node.right = right
    node.leftNeighbor = neighbor
    return (node, newNeighbor!)
}

func treeToStr(root: Node) -> String {
    var str = ""
    if let left = root.left {
        str += "["
        str += treeToStr(root: left)
    }
    if let right = root.right {
        str += ","
        str += treeToStr(root: right)
        str += "]"
    }
    if let val = root.value {
        str += String(val, radix: 10)
    }
    return str
}

func addLeft(root: inout Node, value: Int) {
    var right = root
    while right.right != nil {
        right = right.right!
    }
    right.value = right.value! + value
}

func explode(root: inout Node, level: Int) -> Bool {
    if let leftVal = root.left?.value, let rightVal = root.right?.value, level > 3 {
        root.value = 0
        root.left!.leftNeighbor?.value = root.left!.leftNeighbor!.value! + leftVal
        root.right!.rightNeighbor?.value = root.right!.rightNeighbor!.value! + rightVal
        root.left = nil
        root.right = nil
        return true
    } else {
        if root.left != nil {
            if explode(root: &root.left!, level: level+1) {
                return true
            }
        }
        if root.right != nil {
            if explode(root: &root.right!, level: level+1) {
                return true
            }
        }
        return false
    }
}

func split(root: inout Node) -> Bool {
    if let value = root.value {
        if value > 9 {
            root.value = nil
            root.left = Node(left: nil, right: nil, value:  Int(floor(Double(value)/2)), leftNeighbor: nil, rightNeighbor: nil)
            root.right = Node(left: nil, right: nil, value: Int(ceil(Double(value)/2)), leftNeighbor: nil, rightNeighbor: nil)
            return true
        }
        return false
    } else {
        if root.left != nil {
            if split(root: &root.left!) {
                return true
            }
        }
        if root.right != nil {
            if split(root: &root.right!) {
                return true
            }
        }
        return false
    }
}


func reduce(number: String) -> String {
    var str = ""
    var aTree = tree(number: number, neighbor: nil).newNode
    while true {
        while explode(root: &aTree, level: 0) {
            str = treeToStr(root: aTree)
            //print(str)
            aTree = tree(number: str, neighbor: nil).newNode
        }
        str = treeToStr(root: aTree)
        //print(str)
        aTree = tree(number: str, neighbor: nil).newNode
        if !split(root: &aTree) {
            break
        }
        str = treeToStr(root: aTree)
        //print(str)
        aTree = tree(number: str, neighbor: nil).newNode
    }
    return treeToStr(root: aTree)
}

func magnitude(number: String) -> Int {
    let aTree = tree(number: number, neighbor: nil).newNode
    return nodeMagnitude(root: aTree)
}

func nodeMagnitude(root: Node) -> Int {
    var leftMag = 0
    var rightMag = 0
    if let leftVal = root.left?.value {
        leftMag = leftVal * 3
    } else if root.left != nil {
        leftMag = nodeMagnitude(root: root.left!) * 3
    }
    if let rightVal = root.right?.value {
        rightMag = rightVal * 2
    } else if root.right != nil {
        rightMag = nodeMagnitude(root: root.right!) * 2
    }
    return leftMag + rightMag
}

/*
let test1 = tree(number: "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]", neighbor: nil)
print("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
print(treeToStr(root: test1.newNode))

var test2 = test1.newNode
while explode(root: &test2, level: 0) {
    print(treeToStr(root: test2))
}
print("[[[[0,7],4],[7,[[8,4],9]]],[1,1]]")
print(treeToStr(root: test2))
*/

func computeHomework(lines: [String]) -> Int {
    var number = ""
    for line in lines {
        if number.isEmpty {
            number = line
        } else {
            number = addNumbers(a: number, b: line)
            number = reduce(number: number)
        }
    }
    return magnitude(number: number)
}

func computeHomework2(lines: [String]) -> Int {
    var maxMagnitude = Int.min
    for i in 0..<lines.count {
        for j in i+1..<lines.count {
            let var1 = addNumbers(a: lines[i], b: lines[j])
            let reduced1 = reduce(number: var1)
            let mag1 = magnitude(number: reduced1)
            if mag1 > maxMagnitude {
                maxMagnitude = mag1
            }
            let var2 = addNumbers(a: lines[j], b: lines[i])
            let reduced2 = reduce(number: var2)
            let mag2 = magnitude(number: reduced2)
            if mag2 > maxMagnitude {
                maxMagnitude = mag2
            }
        }
    }
    return maxMagnitude
}

let result = reduce(number: "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
print("")
print("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
print(result)

print(magnitude(number: result))

print(computeHomework(lines: lines))
print(computeHomework2(lines: lines))
