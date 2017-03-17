//
//  File 1.0
//  Created by Caleb Hess on 5/26/16.
//

import Foundation

class File {
    static func string(filename: String) -> String {
        return string(filename, values: [:])
    }
    
    static func string(filename: String, values: [String:String]) -> String {
        var controlHTML = ""
        var fileNamePieces = filename.componentsSeparatedByString(".")
        
        if fileNamePieces.count > 1 {
            do {
                if let filePath = NSBundle.mainBundle().pathForResource(fileNamePieces[0], ofType: fileNamePieces[1]) {
                    controlHTML = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    
                    for (key, value) in values {
                        controlHTML = controlHTML.stringByReplacingOccurrencesOfString("@" + key + "@", withString: value)
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
