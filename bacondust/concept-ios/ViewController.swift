//
//  ViewController.swift
//  March 4, 2017
//  Caleb Hess
//

import UIKit
import WebKit
import GameKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, GKGameCenterControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.black.cgColor
        app = App(parentVC: self)
        
        // load web view
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: "callSwift")
        webCfg.userContentController = userController
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        web = WKWebView(frame: frame, configuration: webCfg)
        web.navigationDelegate = self
        web.scrollView.bounces = false
        web.scrollView.isScrollEnabled = false
        web.layer.backgroundColor = UIColor.clear.cgColor
        web.backgroundColor = UIColor.clear
        web.scrollView.backgroundColor = UIColor.clear
        web.isOpaque = false
        web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let fileURL = Bundle.main.url(forResource: "html/_index", withExtension: "html") {
            web.loadFileURL(fileURL, allowingReadAccessTo: Bundle.main.bundleURL)
        }
        
        self.view.addSubview(web)
        
        
        
        
        
        authenticateLocalPlayer()
    }
    
    
    
    
    
    
    
    
    
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    func setGameCenterScore(score: Int) {
        let bestScoreInt = GKScore(leaderboardIdentifier: Fig.gameCenterLeaderboardID)
        
        bestScoreInt.value = Int64(score)
        
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func checkGCLeaderboard() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
