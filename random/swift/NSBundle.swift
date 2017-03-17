//
//  NSBundle 1.0
//  Created by Caleb Hess on 2/22/16.
//

public extension NSBundle {
    public var versionNumber: String {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        
        return ""
    }
    
    public var buildNumber: String {
        if let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        
        return ""
    }
    
    public var versionAndBuild: String{
        return self.versionNumber + " - (" + self.buildNumber + ")"
    }
}
