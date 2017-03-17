//
//  Export 1.0
//  Created by Caleb Hess on 2/22/16.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

class Export {
    func email(address: String, subject: String, body: String) {
        openSafeURL("mailto:" + address + "?subject=" + subject + "&body=" + body)
    }
    
    func text(number: String, body: String) {
        openSafeURL("sms:" + number + "&body=" + body)
    }
    
    func phone(number: String, prompt: Bool) {
        #if os(iOS)
            openSafeURL("tel" + (prompt ? "prompt:" : ":") + number)
        #else
            print("phone url scheme not available for OS X")
        #endif
    }
    
    func openSafeURL(url: String) {
        if let clean = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            if let nsurl = NSURL(string: clean) {
                #if os(OSX)
                    NSWorkspace.sharedWorkspace().openURL(nsurl)
                #else
                    UIApplication.sharedApplication().openURL(nsurl)
                #endif
            } else {
                print("could not form url")
            }
        } else {
            print("could not form url")
        }
    }
    
    func openWebsite(url: String) {
        if url.indexOf("http://") == 0 || url.indexOf("https://") == 0 {
            openSafeURL(url)
        }
        
        openSafeURL("http://" + url)
    }
}
