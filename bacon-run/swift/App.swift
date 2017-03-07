//
//  App.swift
//  March 4, 2017
//  Caleb Hess
//

import WebKit

class App: SkyManager {
    var web: WKWebView!
    var parent: ViewController!
    
    init(parentVC: ViewController) {
        super.init()
        parent = parentVC
        skyActions = [
            "print"
        ]
    }
    
    func doneLoading() {
        // webView is done loading
    }
    
    func evaluateJavaScript(scope: String, action: String, params: NSDictionary) {
        if scope == "sky" {
            sky(action, params: params)
        } else {
            for (label, child) in self.children {
                if let obj = child as? Sky {
                    if label == scope {
                        if let f = obj.sky[action] {
                            f.run(web, params: params)
                        } else {
                            print("App: child does not have exposed functions")
                        }
                    } else {
                        print("App: label does not equal scope")
                    }
                }
            }
        }
    }
    
    func sky(_ action: String, params: NSDictionary) {
        switch action {
        case "print":
            print(params.string("msg"))
        default:
            print("App: could not evaluate sky")
        }
    }
}
