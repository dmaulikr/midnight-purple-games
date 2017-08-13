//
//  ViewController.swift
//  March 4, 2017
//  Caleb Hess
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKScriptMessageHandler {
    override func viewDidLoad() {
        super.viewDidLoad()
        app = App(parentVC: self)
        
        // load web view
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: "callSwift")
        webCfg.userContentController = userController
        web = WKWebView(frame: CGRect.zero, configuration: webCfg)
        web.navigationDelegate = self
        
        if let fileURL = Bundle.main.url(forResource: "html/_index", withExtension: "html") {
            web.loadFileURL(fileURL, allowingReadAccessTo: Bundle.main.bundleURL)
        }
        
        self.view = web
    }
    
    override func viewDidAppear() {
        self.view.window!.minSize.width = 800
        self.view.window!.minSize.height = 600
        
        // bring to front
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let sky = File.sharedJavaScript("sky.js", values: ["swift-gen": app.script])
        web.html("sky-script", content: sky)
        web.js("init();")
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
}
