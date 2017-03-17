//
//  ViewController.swift
//  app
//
//  Created by caleb on 3/21/16.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var app: App!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.blackColor().CGColor
        app = App(parent: self)
        
        // load web view
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.addScriptMessageHandler(self, name: "callSwift")
        webCfg.userContentController = userController;
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        app.web = WKWebView(frame: frame, configuration: webCfg)
        app.web.navigationDelegate = self
        app.web.scrollView.bounces = false
        app.web.scrollView.scrollEnabled = false
        app.web.layer.backgroundColor = UIColor.clearColor().CGColor
        app.web.backgroundColor = UIColor.clearColor()
        app.web.scrollView.backgroundColor = UIColor.clearColor()
        app.web.opaque = false
        app.web.loadHTMLString(app.web.appHTML(), baseURL: nil)
        self.view.addSubview(app.web)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        app.web.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        app.doneLoading()
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let json = JSON(str: String(message.body))
        let native = json.string("native")
        let data = JSON(dictionary: json.dict("data"))
        app.evaluateJavaScript(native, data: data)
    }
}
