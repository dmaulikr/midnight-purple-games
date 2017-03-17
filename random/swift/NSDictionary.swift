//
//  NSDictionary 1.0
//  Created by Caleb Hess on 3/4/16.
//

import Foundation

public extension NSDictionary {
    public func possibleIntForKey(key: String) -> Int {
        if let possible = self.objectForKey(key) {
            if let n = Int(String(possible)) {
                return n
            }
        }
        
        return 0
    }
    
    public func possibleStringForKey(key: String) -> String {
        if let possible = self.objectForKey(key) {
            return String(possible)
        }
        
        return ""
    }
}
