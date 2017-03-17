//
//  ViewController.swift
//  Score Card
//
//  Created by caleb on 7/14/15.
//  Copyright (c) 2015 Midnight Purple Games. All rights reserved.
//

import UIKit
import WebKit
import Foundation
import Crashlytics
import Fabric

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var web = WKWebView()
    var cssFileNames = ["style", "menu", "name_entry", "archive", "scorecard", "areyousure_menu", "stroke_entry"]
    var imageFileNames = ["golf_blur"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    func loadWebView() {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.addScriptMessageHandler(self, name: "callSwift")
        webCfg.userContentController = userController;
        
        let webFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        web = WKWebView(frame: webFrame, configuration: webCfg)
        web.navigationDelegate = self
        web.scrollView.bounces = false
        web.scrollView.scrollEnabled = false
        web.layer.backgroundColor = UIColor.clearColor().CGColor
        web.backgroundColor = UIColor.clearColor()
        web.scrollView.backgroundColor = UIColor.clearColor()
        web.opaque = false
        web.loadHTMLString(web.appHTML(), baseURL: nil)
        self.view.addSubview(web)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        // ...
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let data = String(message.body).dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
                if let validNative = json.objectForKey("native") {
                    let native = String(validNative)
                    
                    if let validData = json.objectForKey("data") {
                        let data = String(validData)
                        evaluateJavaScriptMessage(native, data: data)
                    }
                }
            } catch {
                print("Coudn't parse " + String(message.body))
            }
        } else {
            print("Couldn't parse " + String(message.body))
        }
    }
    
    func evaluateJavaScriptMessage(native: String, data: String) {
        switch native {
        case "SendText":
            Export().text("", body: "Check out this cool app I found on my iPhone: https://itunes.apple.com/us/app/mini-golf-score-card-free/id1020335183?mt=8")
            Answers.logCustomEventWithName("Share", customAttributes: ["Type": "Text"])
        case "Holes":
            Answers.logCustomEventWithName("Settings", customAttributes: ["Holes": data])
        case "Log":
            print(data)
        default:
            print("Invalid call from JavaScript")
        }
    }
}

