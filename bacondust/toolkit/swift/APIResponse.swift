//
//  APIResponse.swift
//  May 27, 2017
//  Caleb Hess
//
//  toolkit-swift
//

public class APIResponse {
    var statusCode = -1
    var statusText = "(request failure)"
    var requestURL = "(no requestURL)"
    var result = "(no result)"
    var json: NSDictionary = [:]
    
    init(_ response: DataResponse<String>) {
        if let request = response.request {
            if let url = request.url {
                requestURL = String(describing: url)
            }
        }
        
        if let error = response.result.error {
            switch error._code {
            case -1001:
                statusCode = -1001
                statusText = "slow network connection"
            case -1009:
                statusCode = -1009
                statusText = "no network connection"
            default:
                statusCode = -1
                statusText = "request failure"
            }
        } else if response.result.isSuccess {
            if let responseStr = response.result.value {
                result = responseStr
                json = JSON.parse(result)
                statusCode = json.int("status")
                statusText = json.string("status_text")
            }
        }
    }
    
    var data: NSDictionary {
        return json.dict("data")
    }
    
    var dataList: [NSDictionary] {
        return json.array("data")
    }
    
    var dataString: String {
        return json.string("data")
    }
}
