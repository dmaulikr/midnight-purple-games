//
//  Sky.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

public class Sky {
    public var sky = [String: SkyFunction]()
}

open class SkyManager {
    public var skyActions: [String]!
    
    public init() {
        // needed for super.init
    }
    
    public var children: [(String, Any)] {
        let children = Mirror(reflecting: self).children
        var result = [(String, Any)]()
        
        for child in children {
            if let label = child.label {
                result.append(label, child.value)
            }
        }
        
        return result
    }
    
    public var script: String {
        var scopes = ""
        var functions = ""
        
        for (label, value) in self.children {
            if let obj = value as? Sky {
                scopes += label + ":{}"
                functions += obj.sky.map({ $0.value.script(scope: label, method: $0.key) }).joined(separator: ";")
            }
        }
        
        functions += skyActions.map({ actionScript($0) }).joined(separator: ";")
        
        return "var sky={scope:'sky'," + scopes + "};" + functions
    }
    
    public func actionScript(_ f: String) -> String {
        return "sky." + f + " = function (params) { sky.native('sky', '" + f + "', params); };"
    }
}
