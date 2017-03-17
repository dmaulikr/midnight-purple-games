//
//  Math 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

prefix operator ++
postfix operator ++
prefix operator --
postfix operator --

prefix func ++(x: inout Int) -> Int {
    x += 1
    return x
}

postfix func ++(x: inout Int) -> Int {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout UInt) -> UInt {
    x += 1
    return x
}

postfix func ++(x: inout UInt) -> UInt {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout Int8) -> Int8 {
    x += 1
    return x
}

postfix func ++(x: inout Int8) -> Int8 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout UInt8) -> UInt8 {
    x += 1
    return x
}

postfix func ++(x: inout UInt8) -> UInt8 {
    x += 1
    return (x - 1)
}
prefix func ++(x: inout Int16) -> Int16 {
    x += 1
    return x
}

postfix func ++(x: inout Int16) -> Int16 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout UInt16) -> UInt16 {
    x += 1
    return x
}

postfix func ++(x: inout UInt16) -> UInt16 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout Int32) -> Int32 {
    x += 1
    return x
}

postfix func ++(x: inout Int32) -> Int32 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout UInt32) -> UInt32 {
    x += 1
    return x
}

postfix func ++(x: inout UInt32) -> UInt32 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout Int64) -> Int64 {
    x += 1
    return x
}

postfix func ++(x: inout Int64) -> Int64 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout UInt64) -> UInt64 {
    x += 1
    return x
}

postfix func ++(x: inout UInt64) -> UInt64 {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout Double) -> Double {
    x += 1
    return x
}

postfix func ++(x: inout Double) -> Double {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout Float) -> Float {
    x += 1
    return x
}

postfix func ++(x: inout Float) -> Float {
    x += 1
    return (x - 1)
}

prefix func --(x: inout Int) -> Int {
    x -= 1
    return x
}

postfix func --(x: inout Int) -> Int {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout UInt) -> UInt {
    x -= 1
    return x
}

postfix func --(x: inout UInt) -> UInt {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout Int8) -> Int8 {
    x -= 1
    return x
}

postfix func --(x: inout Int8) -> Int8 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout UInt8) -> UInt8 {
    x -= 1
    return x
}

postfix func --(x: inout UInt8) -> UInt8 {
    x -= 1
    return (x + 1)
}
prefix func --(x: inout Int16) -> Int16 {
    x -= 1
    return x
}

postfix func --(x: inout Int16) -> Int16 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout UInt16) -> UInt16 {
    x -= 1
    return x
}

postfix func --(x: inout UInt16) -> UInt16 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout Int32) -> Int32 {
    x -= 1
    return x
}

postfix func --(x: inout Int32) -> Int32 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout UInt32) -> UInt32 {
    x -= 1
    return x
}

postfix func --(x: inout UInt32) -> UInt32 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout Int64) -> Int64 {
    x -= 1
    return x
}

postfix func --(x: inout Int64) -> Int64 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout UInt64) -> UInt64 {
    x -= 1
    return x
}

postfix func --(x: inout UInt64) -> UInt64 {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout Double) -> Double {
    x -= 1
    return x
}

postfix func --(x: inout Double) -> Double {
    x -= 1
    return (x + 1)
}

prefix func --(x: inout Float) -> Float {
    x -= 1
    return x
}

postfix func --(x: inout Float) -> Float {
    x -= 1
    return (x + 1)
}

class Math {
    static func random(_ n: Int, offset: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n))) + offset
    }
}
