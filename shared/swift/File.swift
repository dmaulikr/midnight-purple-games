//
//  File.swift
//  February 6, 2017
//  Caleb Hess
//

import Foundation

public class File {
    public static func sharedHTML(_ filename: String, values: [String: String] = [:]) -> String {
        return string("web/html/" + filename, values: values)
    }
    
    public static func sharedJavaScript(_ filename: String, values: [String: String] = [:]) -> String {
        return string("web/javascript/" + filename, values: values)
    }
    
    public static func html(_ filename: String, values: [String: String] = [:]) -> String {
        return string("html/" + filename + ".html", values: values)
    }
    
    public static func string(_ filename: String, values: [String: String] = [:]) -> String {
        var fileStr = ""
        var fileNamePieces = filename.components(separatedBy: ".")
        
        if fileNamePieces.count > 1 {
            do {
                if let filePath = Bundle.main.path(forResource: fileNamePieces[0], ofType: fileNamePieces[1]) {
                    fileStr = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                    
                    for (key, value) in values {
                        fileStr = fileStr.replace("@" + key + "@", with: value)
                    }
                } else {
                    print("File: could not resolve file path for '" + filename + "'")
                }
            } catch {
                print("File: could not get file contents for '" + filename + "'")
            }
        } else {
            print("File: there is no file extension for '" + filename + "'")
        }
        
        return fileStr
    }
}
