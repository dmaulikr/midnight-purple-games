//
//  App.swift
//  Created by Caleb Hess on 3/21/16.
//

import WebKit
import Fabric
import Crashlytics

class App {
    var web: WKWebView!
    
    init() {
        // ...
    }
    
    func doneLoading() {
        web.js("init();")
        
        let defaults = NSUserDefaults()
        
        if let highScore = defaults.objectForKey("high_score") {
            web.js("highScore = " + String(highScore) + ";")
            web.js("document.getElementById('high_score').innerHTML = " + String(highScore) + ";")
        }
    }
    
    func evaluateJavaScript(native: String, data: JSON) {
        switch native {
        case "SendText":
            Export().text("", body: "Try to beat my high score in Block Runner Pro! Mine is " + data.string("high_score") + " points. https://itunes.apple.com/us/app/block-runner-pro/id1109751913?mt=8")
            Answers.logCustomEventWithName("Challenge", customAttributes: ["Text": data.string("high_score")])
        case "LogScore":
            Answers.logCustomEventWithName("Score", customAttributes: ["Classic (single player)": data.int("score")])
        case "SaveHighScore":
            let defaults = NSUserDefaults()
            defaults.setInteger(data.int("high_score"), forKey: "high_score")
        case "Log":
            print(data.string("log"))
        default:
            print("Error: Could not evaluate JavaScript.")
        }
    }
}
