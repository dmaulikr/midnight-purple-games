//
//  API.swift
//  June 26, 2017
//  Caleb Hess
//
//  toolkit-swift
//

class API {
    class var url: String {
        return "https://vgrcloudwebservice.azurewebsites.net/api/"
    }
    
    static func get(_ api: String, headers: HTTPHeaders = [:], parameters: Parameters = [:], callBack: @escaping (APIResponse) -> Void) {
        request(url + api, method: .get, parameters: parameters, headers: headers).responseString { response in
            callBack(APIResponse(response))
        }
    }
    
    static func post(_ api: String, headers: HTTPHeaders = [:], parameters: Parameters = [:], body: String = "", callBack: @escaping (APIResponse) -> Void) {
        let requestURL = url + api + encodeQueryString(withParameters: parameters)
        
        request(requestURL, method: .post, encoding: body, headers: headers).responseString { response in
            callBack(APIResponse(response))
        }
    }
    
    static func put(_ api: String, headers: HTTPHeaders = [:], parameters: Parameters = [:], body: String = "", callBack: @escaping (APIResponse) -> Void) {
        let requestURL = url + api + encodeQueryString(withParameters: parameters)
        
        request(requestURL, method: .put, encoding: body, headers: headers).responseString { response in
            callBack(APIResponse(response))
        }
    }
    
    static func patch(_ api: String, headers: HTTPHeaders = [:], parameters: Parameters = [:], body: String = "", callBack: @escaping (APIResponse) -> Void) {
        let requestURL = url + api + encodeQueryString(withParameters: parameters)
        
        request(requestURL, method: .patch, encoding: body, headers: headers).responseString { response in
            callBack(APIResponse(response))
        }
    }
    
    static func delete(_ api: String, headers: HTTPHeaders = [:], parameters: Parameters = [:], callBack: @escaping (APIResponse) -> Void) {
        request(url + api, method: .delete, parameters: parameters, headers: headers).responseString { response in
            callBack(APIResponse(response))
        }
    }
    
    static func encodeQueryString(withParameters: Parameters) -> String {
        if withParameters.count > 0 {
            let parameterPairs = withParameters.map({ $0.key + "=" + String(describing: $0.value) })
            let parameterPairsString = parameterPairs.joined(separator: "&")
            
            if let parameterString = parameterPairsString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                return "?" + parameterString
            }
        }
        
        return ""
    }
}
