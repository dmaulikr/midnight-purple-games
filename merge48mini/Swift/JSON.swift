
//
//  JSON 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

class JSON {
    fileprivate var dict: AnyObject?
    var badInt = 0
    var badString = ""
    var error = "error parsing JSON"
    
    init(str: String) {
        if let data = str.data(using: String.Encoding.utf8) {
            do {
                dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
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
    
    static func verify(_ str: String) -> [String] {
        let short = str[1..<str.count - 1]
        
        if str.contains("},{") && (str.indexOf("[{") == 0) && (str.indexOf("}]") == str.count - 2) {
            return short.replace("},{", with: "}$$${").split("$$$")
        }
        
        return [short]
    }
    
    func string(_ key: String) -> String {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                return String(describing: possible)
            }
        }
        
        return badString
    }
    
    func string(_ key: String, ifEmpty: String) -> String {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                if String(describing: possible).count > 0 {
                    return String(describing: possible)
                }
            }
        }
        
        return ifEmpty
    }
    
    func stringArray(_ key: String) -> [String] {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                return possible as! [String]
            }
        }
        
        return []
    }
    
    func int(_ key: String) -> Int {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                if let n = Int(String(describing: possible)) {
                    return n
                }
            }
        }
        
        return badInt
    }
    
    func intArray(_ key: String) -> [Int] {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                return possible as! [Int]
            }
        }
        
        return []
    }
    
    func dict(_ key: String) -> NSDictionary {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                return possible as! NSDictionary
            }
        }
        
        return [:]
    }
    
    func dictArray(_ key: String) -> [NSDictionary] {
        if let json = dict {
            if let possible = json.object(forKey: key) {
                return possible as! [NSDictionary]
            }
        }
        
        return []
    }
}
