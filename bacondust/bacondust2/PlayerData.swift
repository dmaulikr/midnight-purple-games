//
//  PlayerData.swift
//  Bacon Dust
//
//  Created by caleb on 6/13/15.
//  Copyright (c) 2015 Midnight Purple Games. All rights reserved.
//

import Foundation

class PlayerData {
    var db : Connection
    var dataTable : Table
    var eKey = Expression<String>("key")
    var eValue = Expression<Int>("value")
    
    init() {
        db = try! Connection(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/playerprofile.db")
        dataTable = Table("data")
        
        try! db.run(dataTable.create(ifNotExists: true) { t in
            t.column(self.eKey)
            t.column(self.eValue)
        })
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    //                                                                      Score
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func setValue(_ key: String, value: Int) {
        let dataQuery = dataTable.filter(eKey == key)
        
        if try! db.scalar(dataQuery.count) > 0 {
            try! db.run(dataQuery.update(eValue <- value))
        } else {
            try! db.run(dataTable.insert(eKey <- key, eValue <- value))
        }
    }
    
    func highScore() -> Int {
        let highQuery = dataTable.filter(eKey == "highScore")
        
        do {
            if try db.scalar(highQuery.count) > 0 {
                return try db.pluck(highQuery)![eValue]
            }
        } catch {
            print("do catch error")
        }
        
        return 0
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    //                                                                       Utils
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func resetHighScore() {
        try! db.run(dataTable.delete())
    }
}
