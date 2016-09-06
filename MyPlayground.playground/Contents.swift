//: Playground - noun: a place where people can play

import UIKit

struct User {
    
    let userID : String
}

let users = ["2","9","7","3","5","44"]

var userIDString = "["

for userID in users {
    userIDString += userID
    userIDString += ","
}

userIDString = String(userIDString.characters.dropLast())
userIDString += "]"

print(userIDString)

let numbers = [2]

let sum = numbers.reduce(1, combine: *)

print("La suma es => \(sum)")

func arrayToJSONString(array: [String]) -> String {
    return array
        .reduce("") { (acum, userID: String) -> String in
            if acum.isEmpty {
                return "[\(userID)"
            } else {
                return "\(acum),\(userID)"
            }
        }
        .stringByAppendingString("]")
}

func mapToStringArray(array: [Int]) -> [String] {
    return array.map {
        return $0.description
    }
}

infix operator |> { associativity left }
public func |> <A, B> (left: A, right: (A) -> B) -> B {
    return right(left)
}

infix operator >>> { associativity left }
public func >>> <A, B, C> (f: (A) -> B, g: (B) -> C) -> (A) -> C {
    return { (a: A) -> C in
        return g(f(a))
    }
}

let numbersArrayToJSONString = mapToStringArray >>> arrayToJSONString

let userIDString2 = numbers |> numbersArrayToJSONString


print("Para vos rulo, con carinio => \(userIDString2)")






