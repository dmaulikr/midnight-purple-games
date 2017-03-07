//
//  NSDictionary.swift
//  February 3, 2017
//  Caleb Hess
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
    
    public func int(_ key: String, defaultVal: Int = 0) -> Int {
        if let value = self[key] {
            if let n = Int(String(describing: value)) {
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
    
    public func dict(_ key: String, defaultVal: NSDictionary = [:]) -> NSDictionary {
        if let possible = self.object(forKey: key) {
            return possible as? NSDictionary ?? [:]
        }
        
        return defaultVal
    }
    
    public func array(_ key: String, defaultVal: [NSDictionary] = []) -> [NSDictionary] {
        if let possible = self.object(forKey: key) {
            return possible as? [NSDictionary] ?? []
        }
        
        return defaultVal
    }
}
