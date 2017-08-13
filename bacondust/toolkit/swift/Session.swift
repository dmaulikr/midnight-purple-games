//
//  Session.swift
//  June 27, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import WebKit

public class Session {
    var valid = false
    var userGUID = ""
    var userName = ""
    var userPassword = ""
    var userRoles = [String]()
    
    public init() {
        let defaults = UserDefaults.standard
        
        if let savedUserGUID = defaults.string(forKey: "session-userguid") {
            if savedUserGUID != "" {
                valid = true
                userGUID = savedUserGUID
                
                if let savedName = defaults.string(forKey: "session-username") {
                    userName = savedName
                }
                
                if let savedPassword = defaults.string(forKey: "session-password") {
                    userPassword = savedPassword
                }
                
                if let savedRoles = defaults.string(forKey: "session-userroles") {
                    userRoles = savedRoles.split(",")
                }
            }
        }
    }
    
    public func login(_ callBack: @escaping (Bool) -> Void) {
        if userName != "" && userPassword != "" {
            login(userName, password: userPassword, callBack: { success in
                callBack(success)
            })
        } else {
            callBack(false)
        }
    }
    
    public func login(_ username: String, password: String, callBack: @escaping (Bool) -> Void) {
        SSO.auth(username: username, password: password, callBack: { response in
            let success = (response.statusCode < 400 && response.statusCode > 0)
            
            if success {
                let data = response.data
                let rolesArr = data.array("roles")
                
                self.valid = true
                self.userName = username
                self.userPassword = password
                self.userGUID = data.string("nameguid")
                self.userRoles = []
                
                for role in rolesArr {
                    if let roleName = role["rolename"] {
                        self.userRoles.append(String(describing: roleName))
                    }
                }
                
                self.updateUserDefaults()
            }
            
            callBack(success)
        })
    }
    
    func updateUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(userGUID, forKey: "session-userguid")
        defaults.set(userName, forKey: "session-username")
        defaults.set(userPassword, forKey: "session-password")
        defaults.set(userRoles.joined(separator: ","), forKey: "session-userroles")
    }
    
    public func logout() {
        valid = false
        userGUID = ""
        userName = ""
        userRoles = []
        updateUserDefaults()
    }
}
