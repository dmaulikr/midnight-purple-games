//
//  ViewController.swift
//  March 7, 2017
//  Caleb Hess
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var app: App!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app = App(parentVC: self)
        
        // load web view
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: "callSwift")
        webCfg.userContentController = userController;
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        app.web = WKWebView(frame: frame, configuration: webCfg)
        app.web.navigationDelegate = self
        app.web.scrollView.bounces = false
        app.web.scrollView.isScrollEnabled = false
        
        if let fileURL = Bundle.main.url(forResource: "html/_index", withExtension: "html") {
            app.web.loadFileURL(fileURL, allowingReadAccessTo: Bundle.main.bundleURL)
        }
        
        self.view.addSubview(app.web)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        app.web.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let sky = File.sharedJavaScript("sky.js", values: ["swift-gen": app.script])
        app.web.html("sky-script", content: sky)
        app.web.js("init();")
        app.doneLoading()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let json = JSON.parse(String(describing: message.body))
        let scope = json.string("scope")
        let action = json.string("action")
        let params = json.dict("params")
        
        if scope == "sky" {
            app.sky(action, params: params)
        } else {
            for (label, child) in app.children {
                if let obj = child as? Sky {
                    if label == scope {
                        if let f = obj.sky[action] {
                            f.run(app.web, params: params)
                        } else {
                            print("Sky: child does not have exposed functions")
                        }
                    } else {
                        print("Sky: label does not equal scope")
                    }
                }
            }
        }
    }
}
