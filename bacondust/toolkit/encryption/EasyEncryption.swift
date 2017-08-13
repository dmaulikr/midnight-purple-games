//
//  EasyEncryption.swift
//  March 20, 2017
//  Caleb Hess
//

let ENCRYPTION_KEY = "f3gwPjsePefxhVgdQEcyFtndhtfRljomyToBMNoMMvbZea7x"
let ENCRYPTION_KEY_HASH_LENGTH = 32

class EasyEncryption {
    var initializationVector: String!
    var encryption = StringEncryption()
    
    init() {
        initializationVector = encryption.generateRandomIV(16)
    }
    
    func encrypt(_ str: String) -> String {
        if let data = str.data(using: .utf8) {
            let key = encryption.sha256(ENCRYPTION_KEY, length: ENCRYPTION_KEY_HASH_LENGTH)
            
            if let result = encryption.encrypt(data, key: key, iv: initializationVector) {
                return result
            }
        }
        
        return ""
    }
    
    func decrypt(_ str: String) -> String {
        return decrypt(str, vector: initializationVector)
    }
    
    func decrypt(_ str: String, vector: String) -> String {
        if let data = Data(base64Encoded: str, options: []) {
            let key = encryption.sha256(ENCRYPTION_KEY, length: ENCRYPTION_KEY_HASH_LENGTH)
            
            if let result = encryption.decrypt(data, key: key, iv: vector) {
                return result
            }
        }
        
        return ""
    }
}
