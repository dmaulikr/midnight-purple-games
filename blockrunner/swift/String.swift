//
//  String 1.0
//  Created by Caleb Hess on 2/22/16.
//

import Foundation

public extension String {
    public var count: Int { return self.characters.count }
    
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substringWithRange(self.startIndex.advancedBy(r.startIndex)..<self.startIndex.advancedBy(r.endIndex))
    }
    
    public func split(sepearator: String) -> [String] {
        return self.componentsSeparatedByString(sepearator)
    }
    
    public func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    public func replace(target: String, with: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: with)
    }
    
    public func replace(target: String) -> String {
        return replace(target, with: "")
    }
    
    public func replace(values: [String:String]) -> String {
        var result = self
        
        for (target, with) in values {
            result = result.replace(target, with: with)
        }
        
        return result
    }
    
    public func replace(values: [String]) -> String {
        var result = self
        
        for (target) in values {
            result = result.replace(target, with: "")
        }
        
        return result
    }
    
    public func indexOf(target: String) -> Int {
        if let range = self.rangeOfString(target) {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    public func contains(target: String) -> Bool {
        return self.indexOf(target) != -1
    }
}
