//
//  EasyColor.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import Foundation

public class EasyColor {
    public static func rgb(hex: String) -> (Int, Int, Int) {
        var red: CUnsignedInt = 0
        var green: CUnsignedInt = 0
        var blue: CUnsignedInt = 0
        let str = hex.replace("#").uppercased()
        
        if str.count == 3 {
            Scanner(string: str[0] + str[0]).scanHexInt32(&red)
            Scanner(string: str[1] + str[1]).scanHexInt32(&green)
            Scanner(string: str[2] + str[2]).scanHexInt32(&blue)
        } else if str.count == 6 {
            Scanner(string: str[0...1]).scanHexInt32(&red)
            Scanner(string: str[2...3]).scanHexInt32(&green)
            Scanner(string: str[4...5]).scanHexInt32(&blue)
        }
        
        return (Int(red), Int(green), Int(blue))
    }
}
