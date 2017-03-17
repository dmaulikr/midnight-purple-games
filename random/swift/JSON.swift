
//
//  JSON 1.0
//  Created by Caleb Hess on 3/4/16.
//

import Foundation

class JSON {
    private var dict: AnyObject?
    var badInt = 0
    var badString = ""
    var error = "error parsing JSON"
    
    init(str: String) {
        if let data = str.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            } catch {
                print(error)
            }
        } else {
            print(error)
        }
    }
    
    init(dictionary: NSDictionary) {
        dict = dictionary
    }
    
    func string(key: String) -> String {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                return String(possible)
            }
        }
        
        return badString
    }
    
    func string(key: String, ifEmpty: String) -> String {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                if String(possible).count > 0 {
                    return String(possible)
                }
            }
        }
        
        return ifEmpty
    }
    
    func stringArray(key: String) -> [String] {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                return possible as! [String]
            }
        }
        
        return []
    }
    
    func int(key: String) -> Int {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                if let n = Int(String(possible)) {
                    return n
                }
            }
        }
        
        return badInt
    }
    
    func intArray(key: String) -> [Int] {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                return possible as! [Int]
            }
        }
        
        return []
    }
    
    func dict(key: String) -> NSDictionary {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                return possible as! NSDictionary
            }
        }
        
        return [:]
    }
    
    func dictArray(key: String) -> [NSDictionary] {
        if let json = dict {
            if let possible = json.objectForKey(key) {
                return possible as! [NSDictionary]
            }
        }
        
        return []
    }
}
