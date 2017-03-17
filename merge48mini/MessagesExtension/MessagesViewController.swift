//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by caleb on 9/20/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import Messages
import WebKit

class MessagesViewController: MSMessagesAppViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var web: WKWebView!
    var session: MSSession?
    var score = ""
    var themScore = ""
    var grid = ""
    var theirTurn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load web view
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: "callSwift")
        webCfg.userContentController = userController;
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        web = WKWebView(frame: frame, configuration: webCfg)
        web.navigationDelegate = self
        web.scrollView.bounces = false
        web.scrollView.isScrollEnabled = false
        web.layer.backgroundColor = UIColor.clear.cgColor
        web.backgroundColor = UIColor.clear
        web.scrollView.backgroundColor = UIColor.clear
        web.isOpaque = false
        web.loadHTMLString(web.appHTML(), baseURL: nil)
        self.view.addSubview(web)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        web.js("init();")
        
        if session == nil {
            web.js("showCompact();")
        } else {
            if theirTurn {
                web.js("loadGameFromMessage('" + grid + "', '" + score + "', '" + themScore + "', " + String(theirTurn) + ");")
            } else {
                web.js("loadGameFromMessage('" + grid + "', '" + themScore + "', '" + score + "', " + String(theirTurn) + ");")
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let json = JSON(str: String(describing: message.body))
        let native = json.string("native")
        let data = JSON(dictionary: json.dict("data"))
        
        switch native {
        case "Sound":
            print("trying to play sound: " + data.string("name"))
        case "FullScreen":
            self.requestPresentationStyle(.expanded)
        case "SendMessage":
            let d: NSDictionary = [
                "score": data.string("score"),
                "them_score": data.string("them_score"),
                "grid": data.string("grid")
            ]
            
            sendIMessage(json: d.stringify())
        case "Print":
            print(data.string("text"))
        default:
            print("ERROR: Could not evaluate JavaScript. '" + native + "'")
        }
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        if let selected = conversation.selectedMessage {
            session = selected.session
            
            if let url = selected.url {
                guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    fatalError("The message contains an invalid URL")
                }
                
                if let queryItems = components.queryItems {
                    for item in queryItems {
                        if item.name == "json" {
                            if let str = item.value {
                                let json = JSON(str: str)
                                score = json.string("score")
                                themScore = json.string("them_score")
                                grid = json.string("grid")
                            }
                        }
                    }
                }
            }
            
            if conversation.localParticipantIdentifier == selected.senderParticipantIdentifier {
                theirTurn = true
            } else {
                theirTurn = false
            }
        }
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // ...
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // ...
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // ...
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // ....
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            web.js("willTransistion('expanded');")
        } else {
            web.js("willTransistion('compact');")
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // ...
    }
    
    func sendIMessage(json: String) {
        if let image = web.screenshot(), let conversation = activeConversation {
            if session == nil {
                session = MSSession()
            }
            
            let layout = MSMessageTemplateLayout()
            layout.image = image
            
            let message = MSMessage(session: session!)
            message.layout = layout
            
            guard let components = NSURLComponents(string: "https://www.hessfield.com") else {
                fatalError("Invalid base url")
            }
            
            components.queryItems = [URLQueryItem(name: "json", value: json)]
            
            guard let url = components.url  else {
                fatalError("Invalid URL components.")
            }
            
            message.url = url
            
            conversation.insert(message, completionHandler: { error in
                if error != nil {
                    print(error ?? "error in conversation")
                }
            })
            
            self.dismiss()
        }
    }
}
