//
//  Math.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import Foundation

public class Math {
    public static func random(_ n: Int, offset: Int = 0) -> Int {
        return Int(arc4random_uniform(UInt32(n))) + offset
    }
}
