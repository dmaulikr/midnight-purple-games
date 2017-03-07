//
//  String.swift
//  February 3, 2017
//  Caleb Hess
//

import Foundation

public extension String {
    public var count: Int {
        return self.characters.count
    }
    
    public func charAt(_ i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self.charAt(i) as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: self.characters.index(self.startIndex, offsetBy: r.lowerBound)..<self.characters.index(self.startIndex, offsetBy: r.upperBound))
    }
    
    public subscript (r: CountableClosedRange<Int>) -> String {
        return substring(with: self.characters.index(self.startIndex, offsetBy: r.lowerBound)..<self.characters.index(self.startIndex, offsetBy: r.upperBound + 1))
    }
    
    public func split(_ sepearator: String) -> [String] {
        return self.components(separatedBy: sepearator)
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func replace(_ target: String, with: String = "") -> String {
        return self.replacingOccurrences(of: target, with: with)
    }
    
    public func replace(_ values: [String: String]) -> String {
        var result = self
        
        for (target, with) in values {
            result = result.replace(target, with: with)
        }
        
        return result
    }
    
    public func replace(_ values: [String]) -> String {
        var result = self
        
        for (target) in values {
            result = result.replace(target, with: "")
        }
        
        return result
    }
    
    public func wrapSubString(_ subStr: String, before: String, after: String) -> String {
        var index = 0
        var finalString = ""
        
        while index <= self.count - subStr.count {
            let sub = self[index..<index + subStr.count]
            
            if sub.lowercased() == subStr.lowercased() {
                finalString += before + sub + after
                index += subStr.count - 1
            } else {
                finalString += sub[0]
            }
            
            index += 1
        }
        
        return finalString + self[index..<self.count]
    }
    
    public func indexOf(_ target: String) -> Int {
        if let range = self.range(of: target) {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
    
    public func contains(_ target: String) -> Bool {
        return self.indexOf(target) != -1
    }
    
    public func pad(_ count: Int) -> String {
        var result = self
        
        while result.count < count {
            result += " "
        }
        
        return result
    }
}
