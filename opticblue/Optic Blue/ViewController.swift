//
//  ViewController.swift
//  Optic Blue
//
//  Created by caleb on 2/2/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import WebKit
import Fabric
import Crashlytics

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, BirdDelegate {
    var barcodeReader = Bird()
    var web = WKWebView()
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        // set up webview
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.addScriptMessageHandler(self, name: "callSwift")
        webCfg.userContentController = userController;
        
        let webFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        web = WKWebView(frame: webFrame, configuration: webCfg)
        self.view.addSubview(web)
        web.layer.zPosition = 2
        web.navigationDelegate = self
        web.scrollView.bounces = false
        web.scrollView.scrollEnabled = false
        web.layer.backgroundColor = UIColor.clearColor().CGColor
        web.backgroundColor = UIColor.clearColor()
        web.scrollView.backgroundColor = UIColor.clearColor()
        web.opaque = false
        web.loadHTMLString(web.appHTML(), baseURL: nil)
        
        // set up camera
        barcodeReader.start(0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        barcodeReader.delegate = self
        barcodeReader.layer.zPosition = 1
        self.view.addSubview(barcodeReader)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        web.js("init();")
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let data = String(message.body).dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                let native = String(json.objectForKey("native")!)
                let action = String(json.objectForKey("data")!)
                
                switch native {
                case "OpenWebsite":
                    if result.indexOf("www.") == 0 {
                        result = "http://" + result
                    }
                    
                    if let nsurl = NSURL(string: result) {
                        UIApplication.sharedApplication().openURL(nsurl)
                        Answers.logCustomEventWithName("Action", customAttributes: ["type": "open website", "character length": result.count])
                    } else {
                        showAlert("error", msg: "Could not open website.")
                    }
                case "DoAction":
                    if action == "CopyToClipboard" {
                        UIPasteboard.generalPasteboard().string = result
                        showAlert("Copied!", msg: "The value of the barcode was copied to your clipboard.")
                        Answers.logCustomEventWithName("Action", customAttributes: ["type": "copy to clipboard", "character length": result.count])
                    } else if action == "SendEmail" {
                        openEmail("", subject: "", body: urlify(result))
                        Answers.logCustomEventWithName("Action", customAttributes: ["type": "send email", "character length": result.count])
                    } else if action == "SendText" {
                        openText("", body: urlify(result))
                        Answers.logCustomEventWithName("Action", customAttributes: ["type": "send text", "character length": result.count])
                    } else if action == "SearchGoogle" {
                        if let nsurl = NSURL(string: "https://www.google.com/#q=" + urlifyForSearch(result)) {
                            UIApplication.sharedApplication().openURL(nsurl)
                            Answers.logCustomEventWithName("Action", customAttributes: ["type": "search Google", "character length": result.count])
                        } else {
                            showAlert("error", msg: "Could not create Google search URL with value of barcode.")
                        }
                    } else if action == "SearchAmazon" {
                        if let nsurl = NSURL(string: "http://www.amazon.com/s?url=search-alias%3Daps&field-keywords=" + urlifyForSearch(result)) {
                            UIApplication.sharedApplication().openURL(nsurl)
                            Answers.logCustomEventWithName("Action", customAttributes: ["type": "search Amazon", "character length": result.count])
                        } else {
                            showAlert("error", msg: "Could not create Amazon search URL with value of barcode.")
                        }
                    } else if action == "ScanAnother" {
                        resetBarcodeReader()
                    }
                case "Log":
                    print(String(json.objectForKey("data")!))
                default:
                    print("JSON: Invalid class name.")
                }
            } catch {
                print("Coudn't parse " + String(message.body))
            }
        } else {
            print("JSON: Could not parse JSON from JavaScript.")
        }
    }
    
    func showAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        Answers.logCustomEventWithName("Error", customAttributes: ["message": msg])
    }
    
    func readBarcode(code: String) {
        if code.indexOf("www.") == 0 || code.indexOf("http://") == 0 {
            web.js("makeWebsiteAvailable();")
        }
        
        web.innerHTML("result", content: code)
        web.js("openResultsMenu();")
        result = code
    }
    
    func resetBarcodeReader() {
        barcodeReader.clear()
    }
    
    func urlify(str: String) -> String {
        return str.replace(" ", with: "%20")
    }
    
    func urlifyForSearch(str: String) -> String {
        return str.replace(" ", with: "+")
    }
    
    func openEmail(address: String, subject: String, body: String) {
        if let nsurl = NSURL(string: "mailto:" + address + "?subject=" + subject + "&body=" + body) {
            UIApplication.sharedApplication().openURL(nsurl)
        } else {
            showAlert("error", msg: "Could not open email with value of barcode.")
        }
    }
    
    func openText(number: String, body: String) {
        if let nsurl = NSURL(string: "sms:" + number + "&body=" + body) {
            UIApplication.sharedApplication().openURL(nsurl)
        } else {
            showAlert("error", msg: "Could not open text message with value of barcode.")
        }
    }
}

