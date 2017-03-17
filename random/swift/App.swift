//
//  App.swift
//  Created by Caleb Hess on 3/21/16.
//

import WebKit
import Fabric
import Crashlytics

class App {
    var web: WKWebView!
    
    init(parent: ViewController) {
        // ...
    }
    
    func doneLoading() {
        web.js("init();")
    }
    
    func evaluateJavaScript(native: String, data: JSON) {
        switch native {
        case "LogLow":
            Answers.logCustomEventWithName("Range", customAttributes: ["Low": data.int("n")])
        case "LogHigh":
            Answers.logCustomEventWithName("Range", customAttributes: ["High": data.int("n")])
        case "Print":
            print(data.string("text"))
        default:
            print("Error: Could not evaluate JavaScript.")
        }
    }
}
