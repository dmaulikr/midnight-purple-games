//
//  App.swift
//  March 4, 2017
//  Caleb Hess
//

import WebKit

var app: App!
var web: WKWebView!
var session = Session()

class App: SkyManager {
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
    
    func sky(_ action: String, params: NSDictionary) {
        switch action {
        case "print":
            print(params.string("msg"))
        default:
            print("App: could not evaluate sky")
        }
    }
}
