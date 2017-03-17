//
//  Network 1.0
//  Created by Caleb Hess on 2/22/16.
//

import SystemConfiguration

enum WebServiceURLType {
    case Dev, Test, Prod
}

struct NetworkData {
    var requestURL = ""
    var result = ""
    var json: JSON!
}

let webServiceURIType = WebServiceURLType.Dev
let codeFile = "EventData.asmx"

class Network {
    func webServiceURL(method: String) -> String {
        switch webServiceURIType {
        case .Dev:
            return "https://youngfoundations-dev.azurewebsites.net/events/" + codeFile + "/" + method
        case .Test:
            return "https://youngfoundations-test.azurewebsites.net/events/" + codeFile + "/" + method
        default:
            return "https://youngfoundations.org/events/" + codeFile + "/" + method
        }
    }
    
    func connected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func get(method: String, params: [String: String], callBack: (NetworkData) -> Void) {
        if connected() {
            request(.GET, webServiceURL(method), parameters: params).responseString { response in
                if response.result.isSuccess {
                    if let responseStr = response.result.value {
                        var data = NetworkData()
                        data.result = responseStr
                        data.json = JSON(str: responseStr[1..<responseStr.count - 1])
                        
                        if let goodRequest = response.request {
                            if let goodURL = goodRequest.URL {
                                data.requestURL = String(goodURL)
                            }
                        }
                        
                        callBack(data)
                    } else {
                        print("Web Service Call did not return success.")
                    }
                } else {
                    print("Web Service Call did not return success.")
                }
            }
        } else {
            print("No network connection.")
        }
    }
}
