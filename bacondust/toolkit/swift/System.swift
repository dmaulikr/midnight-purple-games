//
//  System.swift
//  August 25, 2017
//  Caleb Hess
//

class System {
    static var iOS: Bool {
        #if os(iOS)
            return true
        #else
            return false
        #endif
    }
    
    static var macOS: Bool {
        return !iOS
    }
}
