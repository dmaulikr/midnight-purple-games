//
//  ViewController.swift
//  bacondust2
//
//  Created by caleb on 2/26/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import WebKit
import Foundation
import AVFoundation

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var web: WKWebView!
    let sound = SoundEffects()
    let playerData = PlayerData()
    let gameMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "m4a")!)
    var gameMusicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
        
        // game music
        gameMusicPlayer = try! AVAudioPlayer(contentsOf: gameMusic)
        gameMusicPlayer.numberOfLoops = -1
        gameMusicPlayer.play()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    //                                                                     WKWebView
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func setUpWebView() {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: "callSwift")
        webCfg.userContentController = userController;
        
        let webFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        web = WKWebView(frame: webFrame, configuration: webCfg)
        self.view.addSubview(web)
        web.navigationDelegate = self
        web.scrollView.bounces = false
        web.scrollView.isScrollEnabled = false
        web.loadHTMLString(web.appHTML(), baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        web.js("init(" + String(playerData.highScore()) + ");")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    //                                                                JavaScript Messages
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = String(describing: message.body).data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                if let validNative = (json as AnyObject).object(forKey: "native") {
                    let native = String(describing: validNative)
                    
                    if let validData = (json as AnyObject).object(forKey: "data") {
                        let data = String(describing: validData)
                        evaluateJavaScriptMessage(native, data: data)
                    }
                }
            } catch {
                print("Coudn't parse " + String(describing: message.body))
            }
        } else {
            print("Couldn't parse " + String(describing: message.body))
        }
    }
    
    func evaluateJavaScriptMessage(_ native: String, data: String) {
        switch native {
        case "Sound":
            sound.playSound(data)
        case "SaveHighScore":
            playerData.setValue("highScore", value: Int(data)!)
        case "Log":
            print(data)
        default:
            NSLog("ERROR: Invalid call from JavaScript to Swift.")
        }
    }
}

