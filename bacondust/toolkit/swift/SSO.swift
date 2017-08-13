//
//  SSO.swift
//  June 27, 2017
//  Caleb Hess
//
//  toolkit-swift
//

class SSO: API {
    override class var url: String {
        return "https://vgr-sso-authorization.azurewebsites.net/api/"
    }
    
    static func auth(username: String, password: String, callBack: @escaping (APIResponse) -> Void) {
        let headers: HTTPHeaders = ["appid": Fig.appGUID]
        let params: NSDictionary = ["username": username, "password": password]
        
        post("v2/authentication/applogin", headers: headers, body: params.stringify, callBack: { response in
            callBack(response)
        })
    }
}
