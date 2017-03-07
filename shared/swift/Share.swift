////
////  Share.swift
////  February 3, 2017
////  Caleb Hess
////
//
//#if os(iOS)
//    import UIKit
//    import MessageUI
//#else
//    import AppKit
//#endif
//
//class Share {
//    static func email(_ vc: ViewController, address: String, subject: String, body: String, isHTML: Bool) {
//        #if os(iOS)
//            if MFMailComposeViewController.canSendMail() {
//                let composeVC = MFMailComposeViewController()
//                composeVC.mailComposeDelegate = vc
//                composeVC.setToRecipients([address])
//                composeVC.setSubject(subject)
//                composeVC.setMessageBody(body, isHTML: isHTML)
//                vc.present(composeVC, animated: true, completion: nil)
//            }
//        #else
//            openSafeURL("mailto:" + address + "?subject=" + subject + "&body=" + body)
//        #endif
//    }
//    
//    static func textMessage(_ vc: ViewController, number: String, body: String) {
//         #if os(iOS)
//            if MFMessageComposeViewController.canSendText() {
//                let composeVC = MFMessageComposeViewController()
//                composeVC.messageComposeDelegate = vc
//                composeVC.recipients = [number]
//                composeVC.body = body
//                vc.present(composeVC, animated: true, completion: nil)
//            }
//        #else
//            openSafeURL("sms:" + number + "&body=" + body)
//        #endif
//    }
//    
//    static func phone(_ number: String, prompt: Bool) {
//        #if os(iOS)
//            openSafeURL("tel" + (prompt ? "prompt:" : ":") + number)
//        #else
//            print("phone url scheme not available for OS X")
//        #endif
//    }
//    
//    static func openSafeURL(_ url: String) {
//        if let clean = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
//            if let nsurl = URL(string: clean) {
//                #if os(OSX)
//                    NSWorkspace.shared().open(nsurl)
//                #else
//                    UIApplication.shared.openURL(nsurl)
//                #endif
//            } else {
//                print("could not form url")
//            }
//        } else {
//            print("could not form url")
//        }
//    }
//    
//    static func openWebsite(_ url: String) {
//        if url.indexOf("http://") == 0 || url.indexOf("https://") == 0 {
//            openSafeURL(url)
//        }
//        
//        openSafeURL("https://" + url)
//    }
//}
