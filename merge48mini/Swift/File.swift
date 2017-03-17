//
//  File 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

class File {
    static func string(_ filename: String) -> String {
        return string(filename, values: [:])
    }
    
    static func string(_ filename: String, values: [String:String]) -> String {
        var controlHTML = ""
        var fileNamePieces = filename.components(separatedBy: ".")
        
        if fileNamePieces.count > 1 {
            do {
                if let filePath = Bundle.main.path(forResource: fileNamePieces[0], ofType: fileNamePieces[1]) {
                    controlHTML = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                    
                    for (key, value) in values {
                        controlHTML = controlHTML.replacingOccurrences(of: "@" + key + "@", with: value)
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
