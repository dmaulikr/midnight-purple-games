//
//  NSBundle 1.0
//  Created by Caleb Hess on 2/22/16.
//

import Foundation

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
    
    public func fileString(filename: String) -> String {
        return fileString(filename, values: [:])
    }
    
    public func fileString(filename: String, values: [String:String]) -> String {
        var controlHTML = ""
        var fileNamePieces = filename.componentsSeparatedByString(".")
        
        if fileNamePieces.count > 1 {
            do {
                if let filePath = NSBundle.mainBundle().pathForResource(fileNamePieces[0], ofType: fileNamePieces[1]) {
                    controlHTML = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    
                    for (key, value) in values {
                        controlHTML = controlHTML.stringByReplacingOccurrencesOfString("@" + key, withString: value)
                    }
                } else {
                    print("ERROR: Could not resolve file path for '" + filename + "'.")
                }
            } catch {
                print("ERROR: Could not get file contents for '" + filename + "'.")
            }
        } else {
            print("ERROR: There is no file extension for '" + filename + "'.")
        }
        
        return controlHTML
    }
}
