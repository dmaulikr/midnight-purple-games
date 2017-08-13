//
//  Bundle.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import Foundation

public extension Bundle {
    public static var versionString: String {
        return self.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public static var buildString: String {
        return self.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    public static var versionStringFull: String {
        return self.versionString + " (" + self.buildString + ")"
    }
    
    public static func savePath(_ file: String) -> String {
        #if os(iOS)
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + file
        #else
            let supportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            return String(describing: supportDirectory.appendingPathComponent(file))
        #endif
    }
}
