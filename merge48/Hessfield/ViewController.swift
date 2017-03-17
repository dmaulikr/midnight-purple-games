//
//  ViewController.swift
//  Hessfield
//
//  Created by caleb on 2/10/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import WebKit
import StoreKit
import Fabric
import Crashlytics
import AVFoundation
import CloudKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var web: WKWebView!
    var cloud = Cloud()
    let productIdentifiers = Set(["com.midnightpurplegames.merge48iap1", "com.midnightpurplegames.merge48iap2"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    var sound = SoundEffects()
    var music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("intense", ofType: "mp3")!)
    var musicPlayer = AVAudioPlayer()
    var gameTimer = 0
    
    override func loadView() {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.addScriptMessageHandler(self, name: "callSwift")
        webCfg.userContentController = userController;
        web = WKWebView(frame: CGRectMake(0, 0, 0, 0), configuration: webCfg)
        web.navigationDelegate = self
        web.scrollView.scrollEnabled = false
        view = web
        
        // set up in app payments
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProductData()

        // timer for analytics
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
        // set up music
        musicPlayer = try! AVAudioPlayer(contentsOfURL: music)
        musicPlayer.numberOfLoops = -1
        
        // music preference
        let defaults = NSUserDefaults()
        
        if let value = defaults.stringForKey("music") {
            if value == "on" {
                musicPlayer.play()
            }
        } else {
            musicPlayer.play()
        }
        
        // CEH only
        //cloud.loadTotalsHoursPlayedByEveryone()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        web.loadHTMLString(web.appHTML(), baseURL: nil)
        
        // check for iCloud data
        let keyStore = NSUbiquitousKeyValueStore.defaultStore();
        let nCenter = NSNotificationCenter.defaultCenter()
        nCenter.addObserver(self, selector: #selector(ViewController.doneSyncing), name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: keyStore)
        keyStore.synchronize()
    }
    
    func doneSyncing() {
        cloud.refresh()
        loadCloudData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func update() {
        gameTimer += 1
    }
    
    func loadCloudData() {
        web.js("coins = " + String(cloud.userCoins))
        web.js("highScore = " + String(cloud.userHighScore))
        web.js("dashHighScore = " + String(cloud.userDashHighScore))
        web.innerHTML("total_time_str", content: totalTimeStr(cloud.userTotalDuration))
        web.js("updateCloudDataUI();")
        
        // welcome user
        if cloud.userName != "" {
            web.innerHTML("company", content: "Hello " + cloud.userName)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        let defaults = NSUserDefaults()
        web.js("init();")
        
        // theme preferences
        if let theme = defaults.stringForKey("theme") {
            Answers.logCustomEventWithName("Settings", customAttributes: ["Theme": theme])
            web.js("document.getElementById('set_" + theme + "').classList.add('settings_selected');")
        }
        
        // music preferences
        if let value = defaults.stringForKey("music") {
            Answers.logCustomEventWithName("Settings", customAttributes: ["Music": value])
            web.js("document.getElementById('set_music" + value + "').classList.add('settings_selected');")
        } else {
            web.js("document.getElementById('set_musicon').classList.add('settings_selected');")
        }
        
        // check for iCloud and load high scores
        if cloud.available() {
            cloud.loadHighScoreList(web)
            Answers.logCustomEventWithName("iCloud", customAttributes: ["Status": "enabled"])
        } else {
            if let _ = defaults.objectForKey("iCloud_warning") {
                Answers.logCustomEventWithName("iCloud", customAttributes: ["Status": "disabled (no warning)"])
            } else {
                let message = "Please enable iCloud Drive in Settings to use this app"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                Answers.logCustomEventWithName("iCloud", customAttributes: ["Status": "disabled (warning)"])
                defaults.setObject("already_shown", forKey: "iCloud_warning")
            }
        }
        
        loadCloudData()
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
        case "SetTheme":
            let defaults = NSUserDefaults()
            defaults.setObject(data, forKey: "theme")
            web.innerHTML("theme_styles", content: NSBundle().fileString(data + ".css"))
        case "SetMusicOn":
            let defaults = NSUserDefaults()
            defaults.setObject("on", forKey: "music")
            musicPlayer.play()
        case "SetMusicOff":
            let defaults = NSUserDefaults()
            defaults.setObject("off", forKey: "music")
            musicPlayer.stop()
        case "SendText":
            if let highScore = Int(data) {
                Answers.logCustomEventWithName("Challenge Sent", customAttributes: ["High Score": highScore])
            }
            
            openText("", body: "Try to beat my high score in Merge 48!%0a%0aMy best score on Classic Mode is " + data + ".%0a%0ahttps://itunes.apple.com/us/app/merge-48/id1084337273?mt=8")
        case "LevelStart":
            gameTimer = 0
        case "LevelEnd":
            if let highScore = Int(data) {
                let totalGameDuration = cloud.userTotalDuration + gameTimer
                let totalHours = (totalGameDuration - totalGameDuration % 3600) / 3600
                let gameCount = cloud.userGameCount + 1
                cloud.updateHighScore(data)
                cloud.updateTotalDuration(String(totalGameDuration))
                cloud.updateGameCount(String(gameCount))
                let gameMinutes = Double(gameTimer) / 60.0
                web.innerHTML("total_time_str", content: totalTimeStr(totalGameDuration))
                cloud.saveStats(totalGameDuration, totalGames: gameCount)
                Answers.logCustomEventWithName("Game", customAttributes: ["Type": "Classic (single player)", "High Score": highScore, "Time Spent Playing (seconds)": gameTimer, "Time Spent Playing (minutes)": gameMinutes, "Total Games": gameCount, "Total Time Spent Playing (hours)": totalHours])
            }
        case "LevelEndWithTimer":
            if let highScore = Int(data) {
                let totalGameDuration = cloud.userTotalDuration + gameTimer
                let totalHours = (totalGameDuration - totalGameDuration % 3600) / 3600
                let gameCount = cloud.userGameCount + 1
                cloud.updateDashHighScore(data)
                cloud.updateTotalDuration(String(totalGameDuration))
                cloud.updateGameCount(String(gameCount))
                let gameMinutes = Double(gameTimer) / 60.0
                web.innerHTML("total_time_str", content: totalTimeStr(totalGameDuration))
                cloud.saveStats(totalGameDuration, totalGames: gameCount)
                Answers.logCustomEventWithName("Game", customAttributes: ["Type": "Dash (single player)", "High Score (Dash)": highScore, "Time Spent Playing (seconds)": gameTimer, "Time Spent Playing (minutes)": gameMinutes, "Total Games": gameCount, "Total Time Spent Playing (hours)": totalHours])
            }
        case "RefreshHighScoreList":
            cloud.loadHighScoreList(web)
        case "UpdateHighScore":
            cloud.updateHighScore(data)
        case "UpdateHighScoreWithTimer":
            cloud.updateDashHighScore(data)
        case "UpdateCoins":
            cloud.updateCoins(data)
        case "BuySmallCoinPackage":
            buyProduct(0)
        case "BuyLargeCoinPackage":
            buyProduct(1)
        case "BuyUnlimitedCoins":
            buyProduct(2)
        case "GetStats":
            if cloud.userName == "" {
                cloud.refresh()
            }
            
            if cloud.userName == "" {
                if cloud.available() {
                    web.js("showNewUserScreen();")
                } else {
                    web.js("showNoICloudScreen();")
                }
            } else {
                web.js("showStatScreen();")
            }
        case "OpenAdmin":
            web.innerHTML("ev_total_hours", content: String(cloud.everyoneTotalHours))
        case "SaveUserName":
            cloud.addUserNameIfNotExists(web, userName: data)
        case "RetryConnection":
            if Network().isConnected() {
                web.js("foundConnection();")
            }
        case "Sound":
            sound.playSound(data)
        case "Log":
            print(data)
        default:
            print("Invalid call from JavaScript")
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    //                                                                      Utils
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func openText(number: String, body: String) {
        let cleanBody = body.replace(" ", with: "%20")
        
        if let nsurl = NSURL(string: "sms:" + number + "&body=" + cleanBody) {
            UIApplication.sharedApplication().openURL(nsurl)
        } else {
            // error opening text message
            print("could no open text")
        }
    }
    
    func openEmail(address: String, subject: String, body: String) {
        let url = "mailto:" + address + "?subject=" + subject + "&body=" + body
        let clean = url.replace(" ", with: "%20").replace("$$$", with: "%0D%0A")
        
        if let nsurl = NSURL(string: clean) {
            UIApplication.sharedApplication().openURL(nsurl)
        } else {
            print("could not form email url")
        }
    }
    
    func totalTimeStr(totalSeconds: Int) -> String {
        let rounded = totalSeconds - totalSeconds % 60
        let minutes = (rounded % 3600) / 60
        let hours = (rounded - rounded % 3600) / 3600
        
        if hours == 0 {
            return String(minutes) + " minutes"
        }
        
        return String(hours) + " hours and " + String(minutes) + " minutes"
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    //                                                                  In App Purchases
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            for index in 0..<products.count {
                self.product = products[index]
                self.productsArray.append(products[index])
            }
        } else {
            print("No products found")
        }
    }
    
    func buyProduct(index: Int) {
        if index < productsArray.count {
            let payment = SKPayment(product: productsArray[index])
            SKPaymentQueue.defaultQueue().addPayment(payment)
        } else {
            web.js("showInfoBox('There was an error loading in app purchase. Your account was not charged.');")
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Failed:
                var errorMsg = ""
                
                if let err = transaction.error {
                    errorMsg = String(err)
                }
                
                Answers.logCustomEventWithName("Real In App Purchase", customAttributes: ["Purchase": "error", "Error": errorMsg])
                web.js("showInfoBox('There was an error. You were not able to purchase any coins.');")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        // ...
    }
    
    func deliverProduct(transaction: SKPaymentTransaction) {
        if transaction.payment.productIdentifier == "com.midnightpurplegames.merge48iap1" {
            coinPurchaseComplete(1000)
            Answers.logCustomEventWithName("Real In App Purchase", customAttributes: ["Purchase": "small coin package"])
        } else if transaction.payment.productIdentifier == "com.midnightpurplegames.merge48iap2" {
            coinPurchaseComplete(5000)
            Answers.logCustomEventWithName("Real In App Purchase", customAttributes: ["Purchase": "large coin package"])
        } else if transaction.payment.productIdentifier == "merge48_unlimited_coins" {
            coinPurchaseComplete(-1)
            Answers.logCustomEventWithName("Real In App Purchase", customAttributes: ["Purchase": "unlimited coins"])
        }
    }
    
    func coinPurchaseComplete(coins: Int) {
        cloud.updateCoins(String(coins))
        
        if coins == -1 {
            // ...
        } else {
            web.js("coins += " + String(coins) + ";")
            web.js("document.getElementById('coins').innerHTML = coins;")
        }
    }
}

