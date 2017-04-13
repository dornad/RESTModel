//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Chillax

let a: JSONDictionary = ["id": 1]
let b: JSONDictionary = ["id": 2]
let c: JSONDictionary = ["id": 3]

let aP = a

let arr_a = [a, b]
let arr_b = [a, b]
let arr_c = [a,b,c]


print(a == b)
print(a == aP)
print(arr_a == arr_b)
print(arr_a == arr_c)


func == <K, V>(left: [K:V], right: [K:V]) -> Bool {
    return NSDictionary(dictionary: left).isEqual(to: right)
}

func == <K, V>(left: [[K:V]], right: [[K:V]]) -> Bool {

    guard left.count == right.count else { return false }

    var result = false

    for leftDict in left {

        var foundMatch = false

        right.forEach { foundMatch = (leftDict == $0) || foundMatch }

        guard foundMatch else { return foundMatch }

        result = foundMatch
    }

    return result
}

PlaygroundPage.current.needsIndefiniteExecution = true



//: [Next](@next)
