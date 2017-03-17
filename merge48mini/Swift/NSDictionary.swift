//
//  NSDictionary 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

public extension NSDictionary {
    public func stringify() -> String {
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
    
    public func int(_ str: String) -> Int {
        if let value = self[str] {
            if let n = Int(String(describing: value)) {
                return n
            }
        }
        
        print("ERROR: could not get integer value from NSMutableDictionary")
        return 0
    }
    
    public func double(_ str: String) -> Double {
        if let value = self[str] {
            if let n =  Double(String(describing: value)) {
                return n
            }
        }
        
        print("ERROR: could not get double value from NSMutableDictionary")
        return 0.0
    }
    
    public func string(_ str: String) -> String {
        if let value = self[str] {
            return String(describing: value)
        }
        
        print("ERROR: could not get string value from NSMutableDictionary")
        return ""
    }
}
