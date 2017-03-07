//
//  Math.swift
//  February 3, 2017
//  Caleb Hess
//

import Foundation

public class Math {
    public static func random(_ n: Int, offset: Int = 0) -> Int {
        return Int(arc4random_uniform(UInt32(n))) + offset
    }
}
