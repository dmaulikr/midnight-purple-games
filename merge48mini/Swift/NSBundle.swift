//
//  NSBundle 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

public extension Bundle {
    static public var versionString: String {
        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return v
        }
        
        return ""
    }
    
    static public var buildString: String {
        if let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return b
        }
        
        return ""
    }
    
    static public var versionStringFull: String {
        return self.versionString + " (" + self.buildString + ")"
    }
}
