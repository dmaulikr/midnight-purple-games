
import WebKit
import CloudKit

class Cloud {
    var userGUID = ""
    var userName = ""
    var userCoins = 500
    var userHighScore = 0
    var userDashHighScore = 0
    var userGameCount = 0
    var userTotalDuration = 0
    var userTrophies = 1000
    var publicCloud = CKContainer.defaultContainer().publicCloudDatabase
    var everyoneTotalHours = 0.0
    
    init() {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let guid = keyStore.stringForKey("userguid") {
            userGUID = guid
            
            if let name = keyStore.stringForKey("username") {
                userName = name
            }
            
            if let value = keyStore.objectForKey("coins") {
                userCoins = Int(String(value))!
            }
            
            if let value = keyStore.objectForKey("highScore") {
                userHighScore = Int(String(value))!
            }
            
            if let value = keyStore.objectForKey("dashHighScore") {
                userDashHighScore = Int(String(value))!
            }
            
            if let value = keyStore.objectForKey("games") {
                userGameCount = Int(String(value))!
            }
            
            if let value = keyStore.objectForKey("duration") {
                userTotalDuration = Int(String(value))!
            }
            
            if let value = keyStore.objectForKey("trophies") {
                userTrophies = Int(String(value))!
            }
        } else {
            userGUID = NSUUID().UUIDString
            keyStore.setString(userGUID, forKey: "userguid")
            keyStore.synchronize()
        }
    }
    
    func refresh() {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let guid = keyStore.stringForKey("userguid") {
            userGUID = guid
        }
        
        if let name = keyStore.stringForKey("username") {
            userName = name
        }
        
        if let value = keyStore.objectForKey("coins") {
            userCoins = Int(String(value))!
        }
        
        if let value = keyStore.objectForKey("highScore") {
            userHighScore = Int(String(value))!
        }
        
        if let value = keyStore.objectForKey("dashHighScore") {
            userDashHighScore = Int(String(value))!
        }
        
        if let value = keyStore.objectForKey("games") {
            userGameCount = Int(String(value))!
        }
        
        if let value = keyStore.objectForKey("duration") {
            userTotalDuration = Int(String(value))!
        }
        
        if let value = keyStore.objectForKey("trophies") {
            userTrophies = Int(String(value))!
        }
    }
    
    func updateCoins(coins: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let coinValue = Int(coins) {
            keyStore.setObject(coinValue, forKey: "coins")
            keyStore.synchronize()
            userCoins = coinValue
        }
    }
    
    func updateTrophies(trophies: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let value = Int(trophies) {
            keyStore.setObject(value, forKey: "trophies")
            keyStore.synchronize()
            userTrophies = value
        }
    }
    
    func updateCoinsIfLess(coins: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let coinValue = Int(coins) {
            if coinValue > userCoins {
                keyStore.setObject(coinValue, forKey: "coins")
                keyStore.synchronize()
                userCoins = coinValue
            }
        }
    }
    
    func updateHighScore(score: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let value = Int(score) {
            if value > userHighScore {
                keyStore.setObject(value, forKey: "highScore")
                keyStore.synchronize()
                userHighScore = value
            }
        }
    }
    
    func updateDashHighScore(score: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let value = Int(score) {
            if value > userDashHighScore {
                keyStore.setObject(value, forKey: "dashHighScore")
                keyStore.synchronize()
                userDashHighScore = value
            }
        }
    }
    
    func updateGameCount(score: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let value = Int(score) {
            if value > userGameCount {
                keyStore.setObject(value, forKey: "games")
                keyStore.synchronize()
                userGameCount = value
            }
        }
    }
    
    func updateTotalDuration(score: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        
        if let value = Int(score) {
            if value > userTotalDuration {
                keyStore.setObject(value, forKey: "duration")
                keyStore.synchronize()
                userTotalDuration = value
            }
        }
    }
    
    func addUserNameIfNotExists(web: WKWebView, userName: String) {
        let query = CKQuery(recordType: "Names", predicate: NSPredicate(format: "username == '" + userName + "'"))
        publicCloud.performQuery(query, inZoneWithID: nil) { results, error in
            if let result = results {
                if result.count == 0 {
                    web.js("goodUserName('" + userName + "');")
                    self.updateCoins("500")
                    self.addUserName(userName)
                } else {
                    web.js("badUserName();")
                }
            }
        }
    }
    
    func loadHighScoreList(web: WKWebView) {
        if available() {
            var cl_i = 1
            var clFound = false
            
            // CLASSIC
            var clHMTL = ""
            let clQuery = CKQuery(recordType: "Stats", predicate: NSPredicate(value: true))
            clQuery.sortDescriptors = [NSSortDescriptor(key: "highScore", ascending: false)]
            publicCloud.performQuery(clQuery, inZoneWithID: nil) { results, error in
                if let scores = results {
                    for score in scores {
                        if let username = score.objectForKey("safename") {
                            if let n = score.objectForKey("highScore") {
                                if cl_i < 11 {
                                    let nameStr = String(cl_i) + ".&nbsp;" + (cl_i < 10 ? "&nbsp;" : "") + String(username)
                                    var xClass = ""
                                    
                                    if String(username) == self.userName {
                                        clFound = true
                                        xClass = "mine"
                                    }
                                    
                                    clHMTL += NSBundle().fileString("highscore_item.html", values: ["name": nameStr, "score": String(n), "xclass": xClass])
                                    cl_i += 1
                                }
                            }
                        }
                    }
                    
                    if !clFound {
                        if self.userName != "" {
                            let params = ["name": self.userName, "score": String(self.userHighScore), "xclass": "mine"]
                            clHMTL += NSBundle().fileString("highscore_item.html", values: params)
                        }
                    }
                    
                    web.innerHTML("cl_high_score_data", content: clHMTL)
                    print("Cloud: classic high score list loaded.")
                }
            }
            
            // DASH
            var i = 1
            var found = false
            var html = ""
            let query = CKQuery(recordType: "Stats", predicate: NSPredicate(value: true))
            query.sortDescriptors = [NSSortDescriptor(key: "dashHighScore", ascending: false)]
            publicCloud.performQuery(query, inZoneWithID: nil) { results, error in
                if let scores = results {
                    for score in scores {
                        if let username = score.objectForKey("safename") {
                            if let n = score.objectForKey("dashHighScore") {
                                if i < 11 {
                                    let nameStr = String(i) + ".&nbsp;" + (i < 10 ? "&nbsp;" : "") + String(username)
                                    var xClass = ""
                                    
                                    if String(username) == self.userName {
                                        found = true
                                        xClass = "mine"
                                    }

                                    html += NSBundle().fileString("highscore_item.html", values: ["name": nameStr, "score": String(n), "xclass": xClass])
                                    i = i + 1
                                }
                            }
                        }
                    }
                    
                    if !found {
                        if self.userName != "" {
                            let params = ["name": self.userName, "score": String(self.userDashHighScore), "xclass": "mine"]
                            html += NSBundle().fileString("highscore_item.html", values: params)
                        }
                    }
                    
                    web.innerHTML("high_score_data", content: html)
                    print("Cloud: dash high score list loaded.")
                }
            }
        }
    }
    
    func loadTotalsHoursPlayedByEveryone() {
        self.everyoneTotalHours = 0.0
        let query = CKQuery(recordType: "Stats", predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 10000000

        queryOperation.recordFetchedBlock = { (record) in
            if let secondsObj = record.objectForKey("totalSeconds") {
                let secondsStr = String(secondsObj)
                
                if let secondsInt = Int(secondsStr) {
                    self.everyoneTotalHours += Double(secondsInt) / 3600.0
                }
            }
        }
        
        queryOperation.queryCompletionBlock = { (cursor, error) in
            print("loaded everyone hours")
        }
        
        publicCloud.addOperation(queryOperation)
    }
    
    func saveStats(totalSeconds: Int, totalGames: Int) {
        if userName != "" {
            if available() {
                publicCloud.fetchRecordWithID(CKRecordID(recordName: userGUID + "stats")) { fetchedPlace, error in
                    if error == nil {
                        if let place = fetchedPlace {
                            place["highScore"] = self.userHighScore
                            place["dashHighScore"] = self.userDashHighScore
                            place["totalSeconds"] = self.userTotalDuration
                            place["totalGames"] = self.userGameCount
                            
                            self.publicCloud.saveRecord(place) { savedPlace, savedError in
                                if error == nil {
                                    print("Cloud: stats updated!")
                                }
                            }
                        }
                    } else {
                        if String(error).contains("Record not found") {
                            self.setUpStats()
                        }
                    }
                }
            }
        }
    }
    
    func setUpStats() {
        let statsPlace = CKRecord(recordType: "Stats", recordID: CKRecordID(recordName: self.userGUID + "stats"))
        
        print("high: " + String(userHighScore))
        print("dash: " + String(userDashHighScore))
        
        statsPlace.setValue(self.userGUID, forKey: "guid")
        statsPlace.setValue(self.userName, forKey: "safename")
        statsPlace.setValue(self.userHighScore, forKey: "highScore")
        statsPlace.setValue(self.userDashHighScore, forKey: "dashHighScore")
        statsPlace.setValue(self.userTotalDuration, forKey: "totalSeconds")
        statsPlace.setValue(self.userGameCount, forKey: "totalGames")
        
        self.publicCloud.saveRecord(statsPlace) { savedRecord, error in
            if error == nil {
                print("Cloud: new stats saved!")
            } else {
                print("Cloud: error saving new stats.")
                print(error)
            }
        }
    }
    
    func addUserName(username: String) {
        let keyStore = NSUbiquitousKeyValueStore()
        let place = CKRecord(recordType: "Names", recordID: CKRecordID(recordName: userGUID + "names"))
        place.setValue(userGUID, forKey: "guid")
        place.setValue(username, forKey: "username")
        place.setValue(username, forKey: "safename")
        place.setValue(0, forKey: "status")
        userName = username
        
        publicCloud.saveRecord(place) { savedRecord, error in
            if error == nil {
                keyStore.setString(self.userName, forKey: "username")
                keyStore.synchronize()
                print("Cloud: new user name saved.")
                self.setUpStats()
            } else {
                print("Cloud: error saving new user name.")
                print(error)
            }
        }
    }
    
    func available() -> Bool {
        return NSFileManager().ubiquityIdentityToken != nil
    }
    
    func resetGame() {
        let keyStore = NSUbiquitousKeyValueStore()
        keyStore.removeObjectForKey("userguid")
        keyStore.removeObjectForKey("username")
        keyStore.removeObjectForKey("coins")
        keyStore.removeObjectForKey("highScore")
        keyStore.removeObjectForKey("dashHighScore")
        keyStore.removeObjectForKey("games")
        keyStore.removeObjectForKey("duration")
        keyStore.removeObjectForKey("trophies")
        keyStore.synchronize()
    }
}
