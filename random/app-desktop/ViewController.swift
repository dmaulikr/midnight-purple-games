//
//  ViewController.swift
//  app-desktop
//
//  Created by caleb on 2/3/16.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var app = App()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load web view
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.addScriptMessageHandler(self, name: "callSwift")
        webCfg.userContentController = userController;
        app.web = WKWebView(frame: CGRectZero, configuration: webCfg)
        app.web.navigationDelegate = self
        app.web.loadHTMLString(app.web.appHTML(), baseURL: nil)
        self.view = app.web
        
        // listen for events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.adjustWindow), name: NSWindowDidResizeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.adjustWindow), name: NSWindowDidMoveNotification, object: nil)
    }
    
    override func viewDidAppear() {
        self.view.window!.minSize.width = 325.0
        self.view.window!.minSize.height = 600.0
        
        // bring to front
        NSApp.activateIgnoringOtherApps(true)
    }
    
    func adjustWindow() {
        let defaults = NSUserDefaults()
        
        if let window = self.view.window {
            let x = Double(window.frame.origin.x)
            let y = Double(window.frame.origin.y)
            let width = Double(window.frame.width)
            let height = Double(window.frame.height)
            defaults.setDouble(x, forKey: "window_x")
            defaults.setDouble(y, forKey: "window_y")
            defaults.setDouble(width, forKey: "window_width")
            defaults.setDouble(height, forKey: "window_height")
        }
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
