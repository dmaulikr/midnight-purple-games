
import WebKit
import CloudKit

class Cloud {
    var userGUID = ""
    var userName = ""
    var userCoins = 0
    var userHighScore = 0
    var publicCloud = CKContainer.default().publicCloudDatabase
    let keyStore = NSUbiquitousKeyValueStore()
    
    init() {
        if let guid = keyStore.string(forKey: "userguid") {
            userGUID = guid
        } else {
            userGUID = UUID().uuidString
            keyStore.set(userGUID, forKey: "userguid")
            keyStore.synchronize()
        }
        
        if let value = keyStore.object(forKey: "username") {
            userName = String(describing: value)
        }
        
        if let value = keyStore.object(forKey: "highscore") {
            userHighScore = Int(String(describing: value))!
        }
    }
    
    func updateHighScore(_ score: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let value = Int(score) {
            if value > userHighScore {
                keyStore.set(value, forKey: "highScore")
                keyStore.synchronize()
                userHighScore = value
            }
        }
    }
    
    func addUserNameIfNotExists(_ web: WKWebView, userName: String) {
        let query = CKQuery(recordType: "Names", predicate: NSPredicate(format: "username == '" + userName + "'"))
        publicCloud.perform(query, inZoneWith: nil) { results, error in
            if let result = results {
                if result.count == 0 {
                    web.js("goodUserName();")
                    self.addUserName(userName)
                } else {
                    web.js("badUserName();")
                }
            }
        }
    }
    
    func loadHighScoreList(_ web: WKWebView) {
        if available() {
            var html = ""
            var i = 1
            let query = CKQuery(recordType: "Stats", predicate: NSPredicate(value: true))
            query.sortDescriptors = [NSSortDescriptor(key: "dashHighScore", ascending: false)]
            publicCloud.perform(query, inZoneWith: nil) { results, error in
                if let scores = results {
                    for score in scores {
                        if let username = score.object(forKey: "safename") {
                            if let n = score.object(forKey: "dashHighScore") {
                                if i < 11 {
                                    let nameStr = String(i) + ". " + String(describing: username)
                                    html += Bundle().fileString("highscore_item.html", values: ["name": nameStr, "score": String(describing: n)])
                                    i = i + 1
                                }
                            }
                        }
                    }
                    
                    web.innerHTML("high_score_data", content: html)
                    print("Cloud: high score list loaded.")
                }
            }
        }
    }
    
    func saveStats(_ totalSeconds: Int, totalGames: Int) {
        if userName != "" {
            if available() {
                publicCloud.fetch(withRecordID: CKRecordID(recordName: userGUID + "stats")) { fetchedPlace, error in
                    if error == nil {
                        if let place = fetchedPlace {
                            place["highscore"] = self.userHighScore as CKRecordValue?
                            
                            self.publicCloud.save(place, completionHandler: { savedPlace, savedError in
                                if error == nil {
                                    print("Cloud: stats updated!")
                                }
                            }) 
                        }
                    } else {
                        if String(describing: error).contains("Record not found") {
                            self.setUpStats()
                        }
                    }
                }
            }
        }
    }
    
    func setUpStats() {
        let statsPlace = CKRecord(recordType: "Stats", recordID: CKRecordID(recordName: self.userGUID + "stats"))
        statsPlace.setValue(self.userGUID, forKey: "guid")
        statsPlace.setValue(self.userName, forKey: "safename")
        statsPlace.setValue(self.userHighScore, forKey: "highscore")
        
        self.publicCloud.save(statsPlace, completionHandler: { savedRecord, error in
            if error == nil {
                print("Cloud: new stats saved!")
            } else {
                print("Cloud: error saving new stats.")
                print(error ?? "error occured")
            }
        }) 
    }
    
    func addUserName(_ username: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        let place = CKRecord(recordType: "Names", recordID: CKRecordID(recordName: userGUID + "names"))
        place.setValue(userGUID, forKey: "guid")
        place.setValue(username, forKey: "username")
        place.setValue(username, forKey: "safename")
        place.setValue(0, forKey: "status")
        userName = username
        
        publicCloud.save(place, completionHandler: { savedRecord, error in
            if error == nil {
                keyStore.set(self.userName, forKey: "username")
                keyStore.synchronize()
                print("Cloud: new user name saved.")
                self.setUpStats()
            } else {
                print("Cloud: error saving new user name.")
                print(error ?? "error")
            }
        }) 
    }
    
    func available() -> Bool {
        return FileManager().ubiquityIdentityToken != nil
    }
    
    func resetGame() {
        let keyStore = NSUbiquitousKeyValueStore()
        keyStore.removeObject(forKey: "userguid")
        keyStore.removeObject(forKey: "username")
        keyStore.removeObject(forKey: "highscore")
        keyStore.synchronize()
    }
}
