//
//  PostParameterEncoding.swift
//  Created by Caleb Hess on 11/15/16.
//

import Foundation

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        
        return request
    }
}
