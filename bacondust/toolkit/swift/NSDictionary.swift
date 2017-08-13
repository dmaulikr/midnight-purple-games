//
//  NSDictionary.swift
//  July 6, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import Foundation

public extension NSDictionary {
    public var stringify: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            
            if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return String(str)
            }
        } catch {
            print(error)
        }
        
        return ""
    }
    
    public var httpBody: String {
        return "\"" + self.stringify.replace("\\\"").replace("\"", with: "\\\"") + "\""
    }
    
    public func bool(_ key: String, defaultVal: Bool = false) -> Bool {
        if let value = self[key] as? Bool {
            return value
        }
        
        return defaultVal
    }
    
    public func int(_ key: String, defaultVal: Int = 0) -> Int {
        if let value = self[key] {
            if let n = Int(String(describing: value)) {
                return n
            }
        }
        
        return defaultVal
    }
    
    public func int64(_ key: String, defaultVal: Int64 = 0) -> Int64 {
        if let value = self[key] {
            if let n = Int64(String(describing: value)) {
                return n
            }
        }
        
        return defaultVal
    }
    
    public func double(_ key: String, defaultVal: Double = 0.0) -> Double {
        if let value = self[key] {
            if let n =  Double(String(describing: value)) {
                return n
            }
        }
        
        return defaultVal
    }
    
    public func string(_ key: String, defaultVal: String = "") -> String {
        if let value = self[key] {
            return String(describing: value)
        }
        
        return defaultVal
    }
    
    public func date(_ key: String, format: String = "yyyy-MM-dd'T'HH:mm:ss", defaultVal: Date = Date(timeIntervalSince1970: 0)) -> Date {
        if let value = self[key] {
            let dateFormatter = DateFormatter()
            let dateString = String(describing: value)
            dateFormatter.dateFormat = format
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        return defaultVal
    }
    
    public func dict(_ key: String, defaultVal: NSDictionary = [:]) -> NSDictionary {
        if let possible = self.object(forKey: key) {
            return possible as? NSDictionary ?? defaultVal
        }
        
        return defaultVal
    }
    
    public func array(_ key: String, defaultVal: [NSDictionary] = []) -> [NSDictionary] {
        var result = defaultVal
        
        if let possible = self.object(forKey: key) {
            result = possible as? [NSDictionary] ?? []
        }
        
        if result == defaultVal || result.count == 0 {
            let singleDict = self.dict(key)
            
            if singleDict.count > 0 {
                return [self.dict(key)]
            }
        }
        
        return result
    }
}
