//
//  JSON.swift
//  February 3, 2017
//  Caleb Hess
//

import Foundation

public class JSON {
    public static func parse(_ str: String) -> NSDictionary {
        if let data = str.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary ?? [:]
            } catch {
                return [:]
            }
        }
        
        return [:]
    }
    
    public static func parseArray(_ str: String) -> [NSDictionary] {
        if let data = str.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [NSDictionary] ?? []
            } catch {
                return []
            }
        }
        
        return []
    }
}
