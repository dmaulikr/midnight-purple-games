//
//  Session.swift
//  August 16, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import WebKit

class Session {
    var valid = false
    var userGUID = ""
    var userName = ""
    var userFirstname = ""
    var userLastname = ""
    var userPassword = ""
    var userRoles = [String]()
    
    init() {
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
    
    func login(_ callBack: @escaping (Bool) -> Void) {
        if userName != "" && userPassword != "" {
            login(userName, password: userPassword, callBack: { success in
                callBack(success)
            })
        } else {
            callBack(false)
        }
    }
    
    func login(_ username: String, password: String, callBack: @escaping (Bool) -> Void) {
        SSO.auth(username: username, password: password, callBack: { response in
            let success = (response.statusCode < 400 && response.statusCode > 0)
            
            if success {
                let data = response.data
                let rolesArr = data.array("roles")
                
                self.valid = true
                self.userName = username
                self.userPassword = password
                self.userFirstname = data.string("firstname")
                self.userLastname = data.string("lastname")
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
    
    var userFullname: String {
        return [userFirstname, userLastname].joined(separator: " ")
    }
    
    func updateUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(userGUID, forKey: "session-userguid")
        defaults.set(userName, forKey: "session-username")
        defaults.set(userPassword, forKey: "session-password")
        defaults.set(userRoles.joined(separator: ","), forKey: "session-userroles")
    }
    
    func logout() {
        valid = false
        userGUID = ""
        userName = ""
        userRoles = []
        updateUserDefaults()
    }
}
