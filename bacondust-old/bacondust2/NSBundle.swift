//
//  NSBundle 1.0
//  Created by Caleb Hess on 2/22/16.
//

import Foundation

public extension Bundle {
    public var versionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        
        return ""
    }
    
    public var buildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        
        return ""
    }
    
    public var versionAndBuild: String{
        return self.versionNumber + " - (" + self.buildNumber + ")"
    }
    
    public func fileString(_ filename: String, values: [String:String]) -> String {
        var controlHTML = ""
        var fileNamePieces = filename.components(separatedBy: ".")
        
        if fileNamePieces.count > 1 {
            do {
                if let filePath = Bundle.main.path(forResource: fileNamePieces[0], ofType: fileNamePieces[1]) {
                    controlHTML = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                    
                    for (key, value) in values {
                        controlHTML = controlHTML.replacingOccurrences(of: "@" + key, with: value)
                    }
                } else {
                    print("VGR FRAMEWORK ERROR: Could not resolve file path for '" + filename + "'.")
                }
            } catch {
                print("VGR FRAMEWORK ERROR: Could not get file contents for '" + filename + "'.")
            }
        } else {
            print("VGR FRAMEWORK ERROR: There is no file extension for '" + filename + "'.")
        }
        
        return controlHTML
    }
}
