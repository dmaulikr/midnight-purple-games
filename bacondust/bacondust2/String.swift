//
//  String 1.0
//  Created by Caleb Hess on 2/22/16.
//

public extension String {
    public var count: Int { return self.characters.count }
    
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
    }
    
    public func split(_ sepearator: String) -> [String] {
        return self.components(separatedBy: sepearator)
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func replace(_ target: String, with: String) -> String {
        return self.replacingOccurrences(of: target, with: with)
    }
    
    public func replace(_ target: String) -> String {
        return replace(target, with: "")
    }
    
    public func replace(_ values: [String:String]) -> String {
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
}
